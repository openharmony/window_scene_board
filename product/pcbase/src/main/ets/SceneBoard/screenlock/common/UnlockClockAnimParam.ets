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

const TAG: string = 'UnlockClockAnimParam';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export enum ClockAnimType {
  TIME,
  DATE
}

export default class UnlockClockAnimParam {

  public static readonly DEFAULT_BLUR_RADIUS: number = 0;

  public static readonly DEFAULT_OPACITY_RATIO: number = 1;

  public static readonly OPACITY_RATIO: number = 0;

  public static readonly DEFAULT_SCALE_RATIO: number = 1;

  public static readonly BLUR_RADIUS: number = 0;

  public static readonly DATE_SCALE_RATIO: number = 1.2;

  public static readonly DATE_BLUR_RADIUS: number = 0;

  public static readonly TIME_SCALE_RATIO: number = 1.4;

  public static readonly TIME_BLUR_RADIUS: number = 0;

  public static readonly DEFAULT_TRANSLATE: number = 0;

  public static readonly DATE_TRANSLATE: number = 36;

  public static readonly TIME_TRANSLATE: number = -70;

  private _dateViewBlur: number = UnlockClockAnimParam.DEFAULT_BLUR_RADIUS;

  public set dateViewBlur(value: number) {
    this._dateViewBlur = value;
  }

  public get dateViewBlur(): number {
    return this._dateViewBlur;
  }

  private _dateViewOpacity: number = UnlockClockAnimParam.DEFAULT_OPACITY_RATIO;

  public set dateViewOpacity(value: number) {
    this._dateViewOpacity = value;
  }

  public get dateViewOpacity(): number {
    return this._dateViewOpacity;
  }

  private _dateViewScale: number = UnlockClockAnimParam.DEFAULT_SCALE_RATIO;

  public set dateViewScale(value: number) {
    this._dateViewScale = value;
  }

  public get dateViewScale(): number {
    return this._dateViewScale;
  }

  private _dateViewTranslate: number | string = UnlockClockAnimParam.DEFAULT_TRANSLATE;

  public set dateViewTranslate(value: number | string) {
    this._dateViewTranslate = value;
  }

  public get dateViewTranslate(): number | string {
    return this._dateViewTranslate;
  }

  private _timeViewBlur: number = UnlockClockAnimParam.DEFAULT_BLUR_RADIUS;

  public set timeViewBlur(value: number) {
    this._timeViewBlur = value;
  }

  public get timeViewBlur(): number {
    return this._timeViewBlur;
  }

  private _timeViewOpacity: number = UnlockClockAnimParam.DEFAULT_OPACITY_RATIO;

  public set timeViewOpacity(value: number) {
    this._timeViewOpacity = value;
  }

  public get timeViewOpacity(): number {
    return this._timeViewOpacity;
  }

  private _timeViewScale: number = UnlockClockAnimParam.DEFAULT_SCALE_RATIO;

  public set timeViewScale(value: number) {
    this._timeViewScale = value;
  }

  public get timeViewScale(): number {
    return this._timeViewScale;
  }

  private _timeViewDigitalScale: number = UnlockClockAnimParam.DEFAULT_SCALE_RATIO;

  public set timeViewDigitalScale(value: number) {
    this._timeViewDigitalScale = value;
  }

  public get timeViewDigitalScale(): number {
    return this._timeViewDigitalScale;
  }

  private _timeViewDigitalTranslate: number | string = UnlockClockAnimParam.DEFAULT_TRANSLATE;

  public set timeViewDigitalTranslate(value: number | string) {
    this._timeViewDigitalTranslate = value;
  }

  public get timeViewDigitalTranslate(): number | string {
    return this._timeViewDigitalTranslate;
  }

  private _isOpenCoverAnimation: boolean = false;

  public set isOpenCoverAnimation(value: boolean) {
    this._isOpenCoverAnimation = value;
  }

  public get isOpenCoverAnimation(): boolean {
    return this._isOpenCoverAnimation;
  }

  private _extendedBlendModeViewHeight: number = 0;

  public set extendedBlendModeViewHeight(value: number) {
    this._extendedBlendModeViewHeight = value;
  }

  public get extendedBlendModeViewHeight(): number {
    return this._extendedBlendModeViewHeight;
  }

  public getOpenCoverExtendedHeight(): number {
    // 移动blendMode组件内的内容，会在父组件边缘处被切割，故需要扩展blendMode组件的高度
    return this.isOpenCoverAnimation ? this.extendedBlendModeViewHeight : 0;
  }

  public getOpenCoverMoveClockViewPositionY(): number {
    // 扩展blendMode组件的高度后，为保证父组件相对位置不变，需要改变父组件起点坐标
    return this.getOpenCoverExtendedHeight() / 2.0;
  }

  public resetParam(): void {
    this.timeViewOpacity = UnlockClockAnimParam.DEFAULT_OPACITY_RATIO;
    this.timeViewDigitalScale = UnlockClockAnimParam.DEFAULT_SCALE_RATIO;
    this.timeViewDigitalTranslate = UnlockClockAnimParam.DEFAULT_TRANSLATE;
    this.timeViewBlur = UnlockClockAnimParam.DEFAULT_BLUR_RADIUS;
    this.dateViewOpacity = UnlockClockAnimParam.DEFAULT_OPACITY_RATIO;
    this.dateViewScale = UnlockClockAnimParam.DEFAULT_SCALE_RATIO;
    this.dateViewTranslate = UnlockClockAnimParam.DEFAULT_TRANSLATE;
    this.dateViewBlur = UnlockClockAnimParam.DEFAULT_BLUR_RADIUS;
  }

  public updateTimeViewParam(): void {
    this.timeViewOpacity = UnlockClockAnimParam.OPACITY_RATIO;
    this.timeViewDigitalScale = UnlockClockAnimParam.TIME_SCALE_RATIO; // 140% time view scale during animation
    this.timeViewDigitalTranslate = UnlockClockAnimParam.TIME_TRANSLATE;
    this.timeViewBlur = UnlockClockAnimParam.TIME_BLUR_RADIUS;
  }

  public updateDateViewParam(): void {
    this.isOpenCoverAnimation = false;
    this.dateViewOpacity = UnlockClockAnimParam.OPACITY_RATIO;
    this.dateViewScale = UnlockClockAnimParam.DATE_SCALE_RATIO; // 120% time view scale during animation
    this.dateViewTranslate = UnlockClockAnimParam.DATE_TRANSLATE;
    this.dateViewBlur = UnlockClockAnimParam.DATE_BLUR_RADIUS;
  }
}