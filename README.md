# Lambda Docker Template

🐳 Containerized AWS Lambda Function with Github Actions CI/CD

## Getting Started

1. Name `local.app` in `aws/main.tf`.
2. Set your aws region in `aws/main.tf`.
3. Create a ECR Repository
4. Overwrite the `data.aws_ecr_repository.this.name` in `aws/github-actions.tf` into the repository's name.
5. Create Github Repository (If you fork this repo, you don't have to do this.)
6. Overwrite the `data.aws_iam_policy_document.actions_assume_role.condition[1].values` in `aws/github-actions.tf` into the repository's name.
7. Once you run `terraform apply`, you can create an IAM role for Github Actions and a Lambda function!
8. Overwrite `.github/workflows/docker-push.yml` as you named previously.
9. Run `yarn install` to install dependencies.
10. Write your function code in `src/index.ts`.
11. Set up the IAM policy document `data.aws_iam_policy_document.lambda` appropriately so that the function works.
12. Set github secrets `AWS_ACCOUNT_ID` and `AWS_REGION`.
13. Make sure you see no error running `yarn lint`.
14. Push your code to the repository.
15. Then the function will be updated automatically!

## Other out-of-the-box settings

- TypeScript
- ESBuild
- ESLint for TypeScript
- Prettier
- Vitest
