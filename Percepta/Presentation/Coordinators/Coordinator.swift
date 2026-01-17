//
//  Coordinator.swift
//  Percepta
//
//  Created by 신종원 on 1/1/26.
//

import SwiftUI

/// Coordinator 패턴 기본 프로토콜
/// 네비게이션 로직을 View와 ViewModel에서 분리하여 관리
///
/// 설계 이유:
/// - View는 UI 렌더링에만 집중
/// - ViewModel은 비즈니스 로직에만 집중
/// - Coordinator가 화면 전환 로직을 담당하여 관심사 분리
protocol Coordinator: ObservableObject {
    associatedtype Route

    /// 현재 표시할 route
    var currentRoute: Route? { get set }

    /// 특정 route로 네비게이션
    func navigate(to route: Route)

    /// 이전 화면으로 돌아가기
    func dismiss()
}
