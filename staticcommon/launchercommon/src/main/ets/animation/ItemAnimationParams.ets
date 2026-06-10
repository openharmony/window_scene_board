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

import curves from '@ohos.curves';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import type { RectInfo } from '@ohos/basicutils';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import { HashMap } from '@kit.ArkTS';
import { SpaceAnimationUtils } from './SpaceAnimationUtils';

const TAG: string = 'ItemAnimationParams';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * 用于计算桌面图标解锁动画。
 */
export class ItemAnimationParams {
  public name: string = '';
  public itemKey: string = '';
  public centerPointDistance: number = 0;
  public itemTranslateX: number = 0;
  public itemTranslateY: number = 0;
  public delay: number = 0;
  public curve?: ICurve;
  public row: number = 0;
  public column: number = 0;
  public index: number = 0;
  public screenCenterX: number = 0;
  public screenCenterY: number = 0;
  public itemCenterX: number = 0;
  public itemCenterY: number = 0;
  public distance: number = 0;
  public rectInfoWidth: number = 0;
  public rectInfoHeight: number = 0;
  private readonly OUTER_LEFT_GRID_ROW: number = 3;
  private readonly OUTER_LEFT_GRID_COL: number = 0;

  private timeMap: HashMap<number, number> = new HashMap();

  constructor(itemKey?: string, name?: string, index?: number) {
    if (itemKey) {
      this.itemKey = itemKey;
    }
    if (name) {
      this.name = name;
    }
    if (index) {
      this.index = index;
    }
  }

  calculateStartAppProperty(screenWidth: number, screenHeight: number, rectInfo: RectInfo) {
    if (screenHeight <= 0 || screenWidth <= 0) {
      log.showWarn('screenHeight is invalid');
      return;
    }
    // 计算动画中心点
    let screenCenterX = Math.round(screenWidth / 2);
    let screenCenterY = Math.round(screenHeight * 0.45);
    // 图标中心点
    let itemCenterX = Math.round((rectInfo.left as number + rectInfo.right as number) / 2);
    let itemCenterY = Math.round((rectInfo.top as number + rectInfo.bottom as number) / 2);
    // 中心点距离 = 图标中心点和动画缩放中心点距离
    this.centerPointDistance = Math.round(Math.sqrt(Math.pow(itemCenterX - screenCenterX, 2) +
      Math.pow(itemCenterY - screenCenterY, 2)));
    // 中心点距离系数 = 中心点距离/屏幕高度；
    let distanceFactor: number = this.centerPointDistance / screenHeight;
    // 当前布局下离中心点最近宫格的距离系数
    let closeDistanceFactor = 0.9 * distanceFactor - 0.65 * distanceFactor * distanceFactor;
    closeDistanceFactor = Math.round(closeDistanceFactor * 1000) / 1000;
    // 动画的初始位移
    this.itemTranslateX = 6 * (itemCenterX - screenCenterX);
    this.itemTranslateY = 6 * (itemCenterY - screenCenterY);
    // 延时
    this.delay = (-0.251 + 4.175 * closeDistanceFactor) * 0.2 * 500 * 1.5;
    // 速度曲线
    this.curve = curves.interpolatingSpring(12.3 + closeDistanceFactor * 3, 1, 110, 20.5);
    log.showInfo('itemTranslateX:%{public}d, itemTranslateY:%{public}d, itemCenterX:%{public}d, itemCenterY:%{public}d,' +
      ' itemKey: %{public}s, screenWidth:%{public}d, screenHeight:%{public}d', this.itemTranslateX, this.itemTranslateY,
      itemCenterX, itemCenterY, this.itemKey, screenWidth, screenHeight);
  }

  calUnlock(screenWidth: number, screenHeight: number, rectInfo: RectInfo) {
    if (screenHeight <= 0 || screenWidth <= 0) {
      log.showWarn('screenHeight is invalid');
      return;
    }

    this.screenCenterX = Math.round(screenWidth / 2);
    this.screenCenterY = Math.round(screenHeight * 0.4);
    // 图标中心点
    this.itemCenterX = Math.round((rectInfo.left as number + rectInfo.right as number) / 2);
    this.itemCenterY = Math.round((rectInfo.bottom as number + rectInfo.top as number) / 2);
    this.rectInfoWidth = rectInfo.right - rectInfo.left;
    this.rectInfoHeight = rectInfo.bottom - rectInfo.top;

    // 获取到当前、最近、最远
    let width = this.screenCenterX - this.itemCenterX;
    let height = this.screenCenterY - this.itemCenterY;
    this.distance = Math.sqrt((width * width) + (height * height));
  }

  calOuterUnlock() {
    let lefGridCenter = GridLayoutUtil.getIconCenterPosition(this.OUTER_LEFT_GRID_ROW, this.OUTER_LEFT_GRID_COL);
    let width = this.screenCenterX - Math.round(lefGridCenter[0]);
    let height = this.screenCenterY - Math.round(lefGridCenter[1]);
    this.distance = Math.sqrt((width * width) + (height * height));
  }

  getDelay(unlockMin: number, unlockMax: number): number {
    let x = Math.abs((this.distance - unlockMin) / unlockMax);
    this.delay = (1.8 * x - 0.8 * x * x) * 300;
    let currentTime = new Date().getTime();
    let formedTime = Math.floor((currentTime + this.delay) / 8);
    formedTime *= 8;
    let realTime = SpaceAnimationUtils.calcRealTime(formedTime, 3);
    this.delay = realTime - currentTime;
    return this.delay;
  }
  // 锁屏swiper区域延时
  getDelayOnLock(unlockMin: number, unlockMax: number): number {
    let x = Math.abs((this.distance - unlockMin) / unlockMax);
    this.delay = (1.8 * x - 0.8 * x * x) * 100;
    let currentTime = new Date().getTime();
    let formedTime = Math.floor((currentTime + this.delay) / 8);
    formedTime *= 8;
    let realTime = SpaceAnimationUtils.calcRealTime(formedTime, 3);
    this.delay = realTime - currentTime;
    return this.delay;
  }
 // 锁屏dock栏区域延时
  getDelayOnLockDock(unlockMin: number, unlockMax: number): number {
    let x = Math.abs((this.distance - unlockMin) / unlockMax);
    this.delay = (1.8 * x - 0.8 * x * x) * 70;
    let currentTime = new Date().getTime();
    let formedTime = Math.floor((currentTime + this.delay) / 8);
    formedTime *= 8;
    let realTime = SpaceAnimationUtils.calcRealTime(formedTime, 3);
    this.delay = realTime - currentTime;
    return this.delay;
  }

  calculateItemFoldProperty(screenWidth: number, screenHeight: number, column: number, row: number) {
    if (screenHeight <= 0 || screenWidth <= 0) {
      log.showWarn(TAG, 'screenHeight or screenWidth is invalid');
      return;
    }
    this.itemTranslateX = 0;
    this.column = column;
    this.row = row;
  }
}