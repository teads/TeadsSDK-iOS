//
//  TeadsSwiftUITypeAliases.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import TeadsSDK

// Short, discoverable names for the official generic `TeadsAdPlacementSwiftUIView<Placement>`.
// Defined here in the sample for now — proposed to move into TeadsSDK (see MR description).

/// SwiftUI view for an InRead (Media) placement.
public typealias TeadsMediaSwiftUIView = TeadsAdPlacementSwiftUIView<TeadsAdPlacementMedia>

/// SwiftUI view for a Feed placement.
public typealias TeadsFeedSwiftUIView = TeadsAdPlacementSwiftUIView<TeadsAdPlacementFeed>
