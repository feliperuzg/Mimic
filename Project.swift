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
            deploymentTarget: .iOS(targetVersion: "10.0", devices: .iphone),
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
            buildAction: .buildAction(targets: ["Mimic"]),
            testAction: .targets(["MimicTests"], options: .options(coverage: true, codeCoverageTargets: ["Mimic"]))
        )
    ],
    resourceSynthesizers: []
)
