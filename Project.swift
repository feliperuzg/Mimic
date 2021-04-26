import ProjectDescription

let project = Project(
    name: "Mimic",
    organizationName: "fruz",
    targets: [
        Target(
            name: "Mimic",
            platform: .iOS,
            product: .framework,
            bundleId: "cl.fruz.Mimic",
            infoPlist: "Sources/Info.plist",
            sources: ["Sources/**"]
        ),
        Target(
            name: "MimicTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "cl.fruz.MimicTests",
            infoPlist: "Tests/Info.plist",
            sources: ["Tests/**"],
            resources: ["Tests/Files/**"],
            dependencies: [
                .target(name: "Mimic")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "Mimic",
            shared: true,
            buildAction: BuildAction(targets: ["Mimic"]),
            testAction: TestAction(
                targets: ["MimicTests"],
                coverage: true,
                codeCoverageTargets: ["Mimic"]
            )
        )
    ]
)
