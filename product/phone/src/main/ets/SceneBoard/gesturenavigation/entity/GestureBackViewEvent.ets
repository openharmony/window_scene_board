/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { GestureBackViewData } from './GestureBackViewData';

/**
 * Back手势ViewEvent
 */
class GestureBackViewEvent {
  public gestureBackViewData: GestureBackViewData = new GestureBackViewData();

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setBackResponseRegionWidth(backResponseRegionWidth: number) {
    this.gestureBackViewData.backResponseRegionWidth_ = backResponseRegionWidth;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getBackResponseRegionWidth(): number {
    return this.gestureBackViewData.backResponseRegionWidth_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setBackTimeThreshold(backTimeThreshold: number) {
    this.gestureBackViewData.backTimeThreshold_ = backTimeThreshold;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getBackTimeThreshold(): number {
    return this.gestureBackViewData.backTimeThreshold_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setBackDistanceThreshold(backDistanceThreshold: number) {
    this.gestureBackViewData.backDistanceThreshold_ = backDistanceThreshold;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getBackDistanceThreshold(): number {
    return this.gestureBackViewData.backDistanceThreshold_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setNeedBackExtrude(needBackExtrude: boolean) {
    this.gestureBackViewData.needBackExtrude_ = needBackExtrude;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getNeedBackExtrude(): boolean {
    return this.gestureBackViewData.needBackExtrude_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setNetaBallFollowingDampX(metaBallFollowingDampX: number) {
    this.gestureBackViewData.metaBallFollowingDampX_ = metaBallFollowingDampX;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getMetaBallFollowingDampX(): number {
    return this.gestureBackViewData.metaBallFollowingDampX_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setMetaBallFollowingDampY(metaBallFollowingDampY: number) {
    this.gestureBackViewData.metaBallFollowingDampY_ = metaBallFollowingDampY;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getMetaBallFollowingDampY(): number {
    return this.gestureBackViewData.metaBallFollowingDampY_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setArrowMoveQuickMaxDistance(arrowMoveQuickMaxDistance: number) {
    this.gestureBackViewData.arrowMoveQuickMaxDistance_ = arrowMoveQuickMaxDistance;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getArrowMoveQuickMaxDistance(): number {
    return this.gestureBackViewData.arrowMoveQuickMaxDistance_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setCancelBackDistanceThreshold(cancelBackDistanceThreshold: number) {
    this.gestureBackViewData.cancelBackDistanceThreshold_ = cancelBackDistanceThreshold;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getCancelBackDistanceThreshold(): number {
    return this.gestureBackViewData.cancelBackDistanceThreshold_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setCancelBackTimeThreshold(cancelBackTimeThreshold: number) {
    this.gestureBackViewData.cancelBackTimeThreshold_ = cancelBackTimeThreshold;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getCancelBackTimeThreshold(): number {
    return this.gestureBackViewData.cancelBackTimeThreshold_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setDrawBezierProcess(drawBezierProcess: number) {
    this.gestureBackViewData.drawBezierProcess_ = drawBezierProcess;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getDrawBezierProcess(): number {
    return this.gestureBackViewData.cancelBackTimeThreshold_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setDrawMetaBallProcess(drawMetaBallProcess: number) {
    this.gestureBackViewData.drawMetaBallProcess_ = drawMetaBallProcess;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getDrawMetaBallProcess(): number {
    return this.gestureBackViewData.drawMetaBallProcess_;
  }

  /**
   * 设置Back手势热区
   *
   * @param backResponseRegionWidth
   */
  public setBezierStartHeight(bezierStartHeight: number) {
    this.gestureBackViewData.bezierStartHeight_ = bezierStartHeight;
  }

  /**
   * 获取Back手势热区
   *
   * @returns
   */
  public getBezierStartHeight(): number {
    return this.gestureBackViewData.bezierStartHeight_;
  }
}