import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "New Module Template",
    attributes: [
        nameAttribute,
    ],
    items: [
        .string(
            path: "Modules/Capabilities/\(nameAttribute)/Sources/\(nameAttribute).swift",
            contents: "import Foundation"
        ),
        .string(
            path: "Modules/Capabilities/\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            contents: "import Foundation"
        ),
        .file(
            path: "Tuist/ProjectDescriptionHelpers/Targets/Capabilities/\(nameAttribute).swift",
            templatePath: "target.stencil"
        ),
    ]
)
