/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* 从app界面开始手势导航的接口回调 */
export interface SCBNavigationFromFullSceneCallback {
  /**
   * 进入app缩放界面
   *
   */
  onEnterSceneZoom(): void;

  /**
   * 退出app缩放界面
   *
   */
  onExitSceneZoom(): void;

  /**
   * 更新app缩放界面
   *
   * @param offsetX 手指偏移的x坐标
   * @param offsetY 手指偏移的y坐标
   */
  onUpdateSceneZoom(offsetX: number, offsetY: number): void;

  /**
   * 进入任务列表界面
   *
   * @param follow 是否跟手
   * @param offsetX 手指偏移的x坐标
   * @param offsetY 手指偏移的y坐标
   */
  onEnterRecent(follow: boolean, offsetX: number, offsetY: number): void;

  /**
   * 更新任务列表界面
   *
   * @param offsetX 手指偏移的x坐标
   * @param offsetY 手指偏移的y坐标
   */
  onUpdateRecent(offsetX: number, offsetY: number): void;

  /**
   * 进入任务列表界面
   *
   * @param follow 是否跟手
   */
  onEnterAppFarView(): void;

  /**
   * 更新app滑到远端的界面
   *
   * @param offsetX 手指偏移的x坐标
   * @param offsetY 手指偏移的y坐标
   */
  onUpdateAppFarView(offsetX: number, offsetY: number, speed: number): void;

  /**
   * 进入桌面
   */
  onEnterHome(): void;

  /**
   * 返回app全屏的状态
   */
  onEnterAppFullScreen(): void;

  /**
   * 进入分屏状态
   */
  onEnterSplit(): void;

  /**
   * Gesture update position
   *
   * @param positionX fingerInfo.globalX
   * @param positionY fingerInfo.globalY
   * @param speed the current speed of gesture event
   */
  onGestureEventUpdate(positionX: number, positionY: number, speed: number): void;

  /**
   * Gesture end position
   *
   * @param positionX fingerInfo.globalX
   * @param positionY fingerInfo.globalY
   */
  onGestureEventEnd(positionX: number, positionY: number): void;

  /**
   * Gesture cancel position
   *
   * @param positionX fingerInfo.globalX
   * @param positionY fingerInfo.globalY
   */
  onGestureEventCancel(positionX: number, positionY: number): void;

  onEnterQuickSwitchFollowingFromAppIdle(): void;
  onEnterHomeIdleFromQuickSwitchFollowing(): void;
  onEnterQuickSwitchIdleFromQuickSwitchFollowing(offsetX: number, offsetY: number): void;
  onEnterAppIdleFromQuickSwitchFollowing(offsetX: number): void;
  onEnterRecentFollowingFromQuickSwitchFollowing(offsetX: number, offsetY: number): void;
  onUpdateQuickSwitchFollowing(offsetX: number, offsetY: number): void;
  onEnterQuickSwitchIdleFromRecentFollowing(offsetX: number, offsetY: number): void;
}

/* 从桌面开始手势导航的接口回调 */
export interface SCBNavigationFromHomeCallback {

  /**
   * 返回HOME的第一页
   */
  onEnterFirstHomePage(): void;

  /**
   * 进入桌面
   */
  onEnterHome(): void;

  /**
   * 进入任务列表界面
   *
   * @param follow 是否跟手
   * @param offsetX 手指偏移的x坐标
   * @param offsetY 手指偏移的y坐标
   */
  onEnterRecent(follow: boolean, offsetX: number, offsetY: number): void;

  /**
   * 更新任务列表界面
   *
   * @param offsetX 手指偏移的x坐标
   * @param offsetY 手指偏移的y坐标
   */
  onUpdateRecent(offsetX: number, offsetY: number): void;

  /**
   * 退出任务列表
   */
  onExitRecent(): void;

  /**
   * 从底部上滑时，更新界面缩放值
   *
   * @param coefficient 系数 , offsetY 位移量
   */
  onUpdateScaleDesktop(offsetY: number): void;

  /**
   * 进入快切应用状态
   * @param follow 是否跟手
   * @param offsetX 手指偏移的x坐标
   * @param offsetY 手指偏移的y坐标
   */
  onEnterSwitch(follow: boolean, offsetX: number, offsetY: number): void;

  /**
   * 更新快切应用状态
   * @param offsetX 手指偏移的x坐标
   * @param offsetY 手指偏移的y坐标
   */
  onUpdateSwitch(offsetX: number, offsetY: number): void;

  /**
   * 退出快切应用状态
   */
  onExitSwitch();

}

/* 从recent界面开始手势导航的接口回调 */
export interface SCBNavigationFromRecentCallback {
  /**
   * 退出任务列表
   */
  onExitRecent();
}