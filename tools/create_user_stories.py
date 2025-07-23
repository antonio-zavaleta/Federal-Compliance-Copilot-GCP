import os
import requests
import subprocess
import yaml
import argparse

# Example usage:
# poetry run python tools/create_user_stories.py --repo antonio-zavaleta/Federal-Compliance-Copilot-GCP --project 3 --owner antonio-zavaleta --yaml tools/gcp_env_setup_stories.yaml
def link_issue_to_epic_and_child(repo, parent_issue_number, child_issue_number, dry_run=False):
	"""
	Adds a comment to the parent (epic) issue referencing the child issue,
	and a comment to the child issue referencing its parent, using the GitHub API.
	"""
	if dry_run:
		print(f"[DRY RUN] Would link child issue #{child_issue_number} to parent (epic) #{parent_issue_number} in {repo}")
		print(f"[DRY RUN] Would link parent (epic) #{parent_issue_number} to child issue #{child_issue_number} in {repo}")
		return
	token = os.environ.get("GITHUB_TOKEN")
	if not token:
		print("GITHUB_TOKEN environment variable not set. Skipping linking.")
		return
	owner, repo_name = repo.split("/")
	headers = {
		"Authorization": f"Bearer {token}",
		"Accept": "application/vnd.github+json"
	}
	# Comment on parent (epic) issue
	url_parent = f"https://api.github.com/repos/{owner}/{repo_name}/issues/{parent_issue_number}/comments"
	comment_body_parent = {
		"body": f"Linked child issue: #{child_issue_number}"
	}
	response_parent = requests.post(url_parent, headers=headers, json=comment_body_parent)
	if response_parent.status_code == 201:
		print(f"Linked issue #{child_issue_number} to parent (epic) #{parent_issue_number} by comment.")
	else:
		print(f"Failed to link issues (parent): {response_parent.status_code} {response_parent.text}")
	# Comment on child issue
	url_child = f"https://api.github.com/repos/{owner}/{repo_name}/issues/{child_issue_number}/comments"
	comment_body_child = {
		"body": f"Linked parent epic: #{parent_issue_number}"
	}
	response_child = requests.post(url_child, headers=headers, json=comment_body_child)
	if response_child.status_code == 201:
		print(f"Linked parent (epic) #{parent_issue_number} to child issue #{child_issue_number} by comment.")
	else:
		print(f"Failed to link issues (child): {response_child.status_code} {response_child.text}")


def run_cmd(cmd, dry_run=False):
	if dry_run:
		print(f"[DRY RUN] {cmd}")
		return ''
	result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
	if result.returncode != 0:
		print(f"Error: {result.stderr}")
	return result.stdout.strip()

def main():
	parser = argparse.ArgumentParser(description="Create GitHub issues from a YAML file and add them to a project board.")
	parser.add_argument("--repo", required=True, help="GitHub repo in the form owner/repo")
	parser.add_argument("--project", required=True, type=int, help="GitHub project number")
	parser.add_argument("--owner", required=True, help="GitHub username or organization for the project board")
	parser.add_argument("--yaml", required=True, help="Path to YAML file with user stories")
	parser.add_argument("--dry-run", action="store_true", default=False, help="Print commands without executing them")
	args = parser.parse_args()

	with open(args.yaml, "r") as f:
		stories = yaml.safe_load(f)

	for story in stories:
		title = story["title"]
		body = story["body"]
		epic_number = story["epic_number"]

		# The --json flag is not supported by 'gh issue create'.
		# Instead, we capture the plain text output and extract the issue URL and number from it.
		issue_cmd = f'gh issue create --repo "{args.repo}" --title "{title}" --body "{body}"'
		issue_output = run_cmd(issue_cmd, dry_run=args.dry_run)
		if args.dry_run:
			continue
		if not issue_output:
			continue
		# The last line of the output is the issue URL
		lines = issue_output.strip().splitlines()
		issue_url = lines[-1] if lines else ''
		print(f"Created issue: {issue_url}")
		# Extract the issue number from the URL
		import re
		match = re.search(r'/issues/(\d+)', issue_url)
		issue_number = match.group(1) if match else None
		if not issue_number:
			print("Could not extract issue number from URL. Skipping linking.")
			continue

		# Add to project board (must specify --owner for non-interactive use)
		run_cmd(f'gh project item-add {args.project} --owner {args.owner} --url {issue_url}', dry_run=args.dry_run)
		print(f"Added to project: {args.project}")

		# Link as child to Epic and add reciprocal comment to child using GitHub API
		link_issue_to_epic_and_child(args.repo, epic_number, issue_number, dry_run=args.dry_run)

if __name__ == "__main__":
	main()
