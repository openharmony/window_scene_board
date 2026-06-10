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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { SlGreetSBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slGreetUtils } from '@ohos/systemuicommon/src/main/ets/TsIndex';

const TAG = 'SlGreetSBindState';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Observed
export class SlGreetSBindState extends WidgetBindState<SlGreetSBindStateType> {
  @Track private greetOpacity: number = 0;
  @Track private greetScale: number = 0;
  @Track private isShow: boolean = false;
  @Track private greetLeftMargin: number = 0;
  @Track private greetTopMargin: number = 0;
  @Track private greetWidth: number = 0;
  @Track private greetHeight: number = 89;
  @Track private bgGreetBlurRadius: number = 0;
  // 背景色
  @Track private backgroundColor?: ResourceColor;
  // 提亮参数
  @Track private brightnessOptions?: BrightnessOptions;

  public setBgGreetBlurRadius(value: number) {
    if (this.bgGreetBlurRadius !== value) {
      log.showInfo(`setBgGreetBlurRadius  ${value}`);
    } else {
      log.showDebug(`setBgGreetBlurRadius  ${value}`);
    }
    this.bgGreetBlurRadius = value;
  }

  public getBgGreetBlurRadius(): number {
    return this.bgGreetBlurRadius;
  }

  public setIsShow(value: boolean): void {
    log.showInfo(`setGreetShowState  ${value}`);
    this.isShow = value;
    slGreetUtils.slGreetViewIsShow = value;
  }

  public getIsShow(): boolean {
    return this.isShow;
  }

  public setGreetScale(value: number): void {
    if (this.greetScale !== value) {
      log.showInfo(`setGreetScale ${value}`);
    } else {
      log.showDebug(`setGreetScale ${value}`);
    }
    this.greetScale = value;
  }

  public getGreetScale(): number {
    return this.greetScale;
  }

  public setGreetOpacity(value: number): void {
    if (this.greetOpacity !== value) {
      log.showInfo(`setGreetOpacity  ${value}`);
    } else {
      log.showDebug(`setGreetOpacity  ${value}`);
    }
    this.greetOpacity = value;
  }

  public getGreetOpacity(): number {
    return this.greetOpacity;
  }

  public setGreetHeight(value: number): void {
    this.greetHeight = value;
  }

  public getGreetHeight(): number {
    return this.greetHeight;
  }

  public setGreetWidth(value: number): void {
    this.greetWidth = value;
  }

  public getGreetWidth(): number {
    return this.greetWidth;
  }

  public setGreetLeftMargin(value: number): void {
    this.greetLeftMargin = value;
  }

  public getGreetLeftMargin(): number {
    return this.greetLeftMargin;
  }

  public setGreetTopMargin(value: number): void {
    this.greetTopMargin = value;
  }

  public getGreetTopMargin(): number {
    return this.greetTopMargin;
  }

  public setBackgroundColor(color: ResourceColor): SlGreetSBindState {
    if (this.backgroundColor !== color) {
      this.backgroundColor = color;
    }
    return this;
  }

  public setBrightness(options: BrightnessOptions): SlGreetSBindState {
    if (this.brightnessOptions !== options) {
      this.brightnessOptions = options;
    }
    return this;
  }

  public getBackgroundColor(): ResourceColor | undefined {
    return this.backgroundColor;
  }

  public getBrightness(): BrightnessOptions | undefined {
    return this.brightnessOptions;
  }


  constructor() {
    super(SlMainStateType.SL_LOCK_GREET_WG_BIND_STATE);
  }
}