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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RotationConstants } from '@ohos/commonconstants';
import { SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import { ScreenLockLayoutManager } from '../common/ScreenLockLayoutManager';
import Constants from '../common/Constants';
import { LayoutAniParamConst } from '../common/AniParamConst';

const TAG = 'ScreenLock-SlLayoutViewData';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);
//在带鱼屏上的缩放系数
const SCALE_ON_HAIRTAIL_SCREEN = 0.6;

export interface SlLayoutRotateParam {
  clockMarginTop: number;
  userTranslateY: number;
}

export class VirtualScreenSize {
  public vScreenWidth: number = 0;
  public vScreenHeight: number = 0;

  constructor();

  constructor(screenProp: SCBScreenProperty);

  constructor(screenProp?: SCBScreenProperty) {
    if (!screenProp) {
      return;
    }
    this.updateByScreenProp(screenProp);
  }

  public isEqual(vScreenSize: VirtualScreenSize): boolean {
    return (this.vScreenWidth === vScreenSize.vScreenWidth) && (this.vScreenHeight === vScreenSize.vScreenHeight);
  }

  public copy(vScreenSize: VirtualScreenSize): void {
    this.vScreenWidth = vScreenSize.vScreenWidth;
    this.vScreenHeight = vScreenSize.vScreenHeight;
  }

  public updateByScreenProp(screenProp: SCBScreenProperty): void {
    this.vScreenWidth = px2vp(screenProp.width);
    this.vScreenHeight = px2vp(screenProp.height);
  }
}

@Observed
export class SlLayoutData {
  @Track public gridRowCnt: number = 0;
  public girdAreaHeight: number = 0;
  public mainScreenProp?: SCBScreenProperty;
  @Track public flexAlign: FlexAlign = FlexAlign.Start;
  @Track public accountTopMargin: number = 0;
  @Track public accountTopMarginInTotal: number = 0;
  @Track public clockTopMargin: number = 0;
  @Track public ratio: number = 1;
  @Track public gridWidth: number = 0;
  @Track public rotateParam?: SlLayoutRotateParam;
  public vScreenSize: VirtualScreenSize = new VirtualScreenSize();

  constructor() {
  }

  public updateData(): boolean {
    this.updateScreenProp();
    if (this.mainScreenProp !== undefined) {
      if (this.mainScreenProp.width / this.mainScreenProp.height > 2) {
        this.ratio = SCALE_ON_HAIRTAIL_SCREEN;
      } else {
        this.ratio = 1;
      }
    } else {
      log.showWarn(`mainScreenProp undefined`);
    }
    this.gridWidth = ScreenLockLayoutManager.getInstance().gridWidth * this.ratio;
    this.updateRotateParam();
    this.updateGridRowCnt();
    this.updateAccountTopMargin();
    if (!this.girdAreaHeight) {
      log.showWarn(`GridAreaHeight is zero`);
      return false;
    }
    return true;
  }

  private updateRotateParam(): void {
    this.rotateParam = LayoutAniParamConst.NO_ROTATION;
  }

  private isHorizon(): boolean {
    return false;
  }

  private updateScreenProp(): void {
    this.mainScreenProp = SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty;
    this.vScreenSize.updateByScreenProp(this.mainScreenProp);
  }

  private updateGridRowCnt(): void {
    const screenLockAreaHeight = this.getScreenLockAreaHeight();
    this.girdAreaHeight = parseFloat(screenLockAreaHeight.toFixed(2)) - Constants.UP_AND_LOWER_HEIGHT;
    this.gridRowCnt = Math.floor(this.girdAreaHeight / this.gridWidth);
    this.flexAlign = FlexAlign.Start;
    if (this.gridRowCnt > 12) {
      this.flexAlign = FlexAlign.Center
      this.gridRowCnt = 12;
    }
  }

  private getScreenLockAreaHeight(): number {
    return this.vScreenSize.vScreenHeight;
  }

  public updateAccountTopMargin(offsetGridNum: number = 0): void {
    const clockToAccountSpace: number = (this.gridRowCnt - Constants.BASE_GIRD_NUM) * this.gridWidth;
    const offsetData: number = this.isHorizon() ? Constants.UF_HORIZONTAL_PADDING : 0;
    this.accountTopMargin = clockToAccountSpace + Constants.ACCOUNTS_MARGIN_TOP;
    this.accountTopMarginInTotal = this.accountTopMargin + Constants.CLOCK_TO_STATUSBAR_GIRD_NUM *
    this.gridWidth + Constants.PADDING_AND_STATUS_BAR;
    log.showInfo(`updateAccountTopMargin: ${this.accountTopMargin}, gridWidth: ${this.gridWidth},
    accountTopMarginInTotal: ${this.accountTopMarginInTotal}, offsetData: ${offsetData}`);
  }
}