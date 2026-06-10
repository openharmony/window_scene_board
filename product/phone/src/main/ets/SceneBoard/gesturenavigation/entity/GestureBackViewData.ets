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

import { GestureBackConstants } from '@ohos/gestureback/src/main/ets/common/GestureBackConstants';

/**
 * Back手势ViewData
 */
@Observed
export class GestureBackViewData {
  public backResponseRegionWidth_: number = GestureBackConstants.BACK_WIDTH;
  public backTimeThreshold_: number = GestureBackConstants.BACK_TIME_THRESHOLD;
  public backDistanceThreshold_: number = GestureBackConstants.BACK_DISTANCE_THRESHOLD;
  public needBackExtrude_: boolean = true;
  public metaBallFollowingDampX_: number = GestureBackConstants.BACK_METABALL_FOLLOWING_DAMP_X;
  public metaBallFollowingDampY_: number = GestureBackConstants.BACK_METABALL_FOLLOWING_DAMP_Y;
  public arrowMoveQuickMaxDistance_: number = GestureBackConstants.ARROW_MOVE_QUICK_MAX_DISTANCE;
  public cancelBackDistanceThreshold_: number = GestureBackConstants.CANCEL_BACK_DISTANCE_THRESHOLD;
  public cancelBackDistanceThreshold120_: number = GestureBackConstants.CANCEL_BACK_DISTANCE_THRESHOLD_120;
  public cancelBackTimeThreshold_: number = GestureBackConstants.CANCEL_BACK_TIME_THRESHOLD;
  public drawBezierProcess_: number = 0;
  public drawMetaBallProcess_: number = 0;
  // 跟手贝塞尔曲线初始的一半高度
  public bezierStartHeight_: number = 80;

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set backResponseRegionWidth(backResponseRegionWidth: number) {
    this.backResponseRegionWidth_ = backResponseRegionWidth;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get backResponseRegionWidth(): number {
    return this.backResponseRegionWidth_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set backTimeThreshold(backTimeThreshold: number) {
    this.backTimeThreshold_ = backTimeThreshold;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get backTimeThreshold(): number {
    return this.backTimeThreshold_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set backDistanceThreshold(backDistanceThreshold: number) {
    this.backDistanceThreshold_ = backDistanceThreshold;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get backDistanceThreshold(): number {
    return this.backDistanceThreshold_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set needBackExtrude(needBackExtrude: boolean) {
    this.needBackExtrude_ = needBackExtrude;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get needBackExtrude(): boolean {
    return this.needBackExtrude_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set metaBallFollowingDampX(metaBallFollowingDampX: number) {
    this.metaBallFollowingDampX_ = metaBallFollowingDampX;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get metaBallFollowingDampX(): number {
    return this.metaBallFollowingDampX_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set metaBallFollowingDampY(metaBallFollowingDampY: number) {
    this.metaBallFollowingDampY_ = metaBallFollowingDampY;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get metaBallFollowingDampY(): number {
    return this.metaBallFollowingDampY_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set arrowMoveQuickMaxDistance(arrowMoveQuickMaxDistance: number) {
    this.arrowMoveQuickMaxDistance_ = arrowMoveQuickMaxDistance;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get arrowMoveQuickMaxDistance(): number {
    return this.arrowMoveQuickMaxDistance_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set cancelBackDistanceThreshold(cancelBackDistanceThreshold: number) {
    this.cancelBackDistanceThreshold_ = cancelBackDistanceThreshold;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get cancelBackDistanceThreshold(): number {
    return this.cancelBackDistanceThreshold_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set cancelBackDistanceThreshold120(cancelBackDistanceThreshold120: number) {
    this.cancelBackDistanceThreshold120_ = cancelBackDistanceThreshold120;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get cancelBackDistanceThreshold120(): number {
    return this.cancelBackDistanceThreshold120_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set cancelBackTimeThreshold(cancelBackTimeThreshold: number) {
    this.cancelBackTimeThreshold_ = cancelBackTimeThreshold;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get cancelBackTimeThreshold(): number {
    return this.cancelBackTimeThreshold_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set drawBezierProcess(drawBezierProcess: number) {
    this.drawBezierProcess_ = drawBezierProcess;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get drawBezierProcess(): number {
    return this.cancelBackTimeThreshold_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set drawMetaBallProcess(drawMetaBallProcess: number) {
    this.drawMetaBallProcess_ = drawMetaBallProcess;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get drawMetaBallProcess(): number {
    return this.drawMetaBallProcess_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public set bezierStartHeight(bezierStartHeight: number) {
    this.bezierStartHeight_ = bezierStartHeight;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public get bezierStartHeight(): number {
    return this.bezierStartHeight_;
  }
}