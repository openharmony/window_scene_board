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

import { SingletonHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import display from '@ohos.display';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'BlurButtonVM';
const SETTING_DIALOG_POSITION_Y = 48;
const SETTING_DIALOG_MAX_HEIGHT = 189;
const NTF_SETTING_BUTTON_HEIGHT = 40;
const NTF_SETTING_BUTTON_END = 197;

@Observed
export class BlurButtonVM {
  /**
   * 点击设置按钮后，需要全屏模糊
   */
  public shouldBlur: boolean = false;
  /**
   * 按钮位置X
   */
  public buttonPositionX: number = 0;

  /**
   * 按钮位置Y
   */
  public buttonPositionY: number = 0;
  /**
   * 按钮是否点击
   */
  public isButtonClick: boolean = false;

  /**
   * 按钮所在父组件的Area属性（TV使用）
   */
  public buttonParentArea: Area | undefined = undefined;

  public getShouldBlur(): boolean {
    return this.shouldBlur;
  }

  public setShouldBlur(shouldBlur: boolean): void {
    this.shouldBlur = shouldBlur;
  }

  public getIsButtonClick(): boolean {
    return this.isButtonClick;
  }

  private getDisplayInfo(): display.Display | null {
    return display.getDefaultDisplaySync();
  }

  public getButtonMargin(): Margin {
    let top = this.buttonPositionY;
    // 给了按钮父组件的area，适配在area中的margin
    if (this.buttonParentArea) {
      return {
        top: top - (this.buttonParentArea.globalPosition?.y as number),
        left: this.buttonPositionX - (this.buttonParentArea.globalPosition?.x as number),
      }
    }
    if (RTLUtil.isRTL()) {
      return {
        top,
        right: ArkUIAdapter.px2vp(this.getDisplayInfo()?.width) - this.buttonPositionX - NTF_SETTING_BUTTON_HEIGHT,
      };
    };
    return {
      top,
      left: this.buttonPositionX,
    };
  }
  /**
   * 背景模糊
   * @param buttonPosition
   */
  public blur(buttonPosition: Position): void {
    this.isButtonClick = true;
    this.shouldBlur = true;
    this.updateButtonPosition(buttonPosition);
  }

  /**
   * 取消背景模糊
   *
   * @param closeBlur 是否关闭模糊层
   */
  public unblur(closeBlur?: boolean): void {
    this.isButtonClick = false;
    if (closeBlur) {
      this.shouldBlur = false;
    }
  }

  /**
   * 获取弹窗相对位置
   *
   * @param dialogId 弹窗id
   * @returns 弹窗相对位置
   */
  public getAlignRules(dialogId: string): AlignRuleOption {
    if (this.checkOverScreenBottom()) {
      if (RTLUtil.isRTL()) {
        return {
          bottom: { anchor: dialogId, align: VerticalAlign.Top },
          left: { anchor: dialogId, align: HorizontalAlign.Start }
        };
      }
      return {
        bottom: { anchor: dialogId, align: VerticalAlign.Top },
        right: { anchor: dialogId, align: HorizontalAlign.End }
      };
    }
    if (RTLUtil.isRTL()) {
      return {
        top: { anchor: dialogId, align: VerticalAlign.Bottom },
        left: { anchor: dialogId, align: HorizontalAlign.Start }
      };
    }
    return {
      top: { anchor: dialogId, align: VerticalAlign.Bottom },
      right: { anchor: dialogId, align: HorizontalAlign.End }
    };
  }

  /**
   * 获取相对位置
   * @returns 获取是否是维吾尔语的右边距值
   */
  getIsRTLRight(): number {
    if (RTLUtil.isRTL()) {
      return (ArkUIAdapter.px2vp(this.getDisplayInfo()?.width) - this.buttonPositionX - NTF_SETTING_BUTTON_HEIGHT)
    }
    return 0
  }

  /**
   * 更新弹窗位置
   * @param buttonPosition
   */
  public updateButtonPosition(buttonPosition: Position): void {
    this.buttonPositionX = buttonPosition.x as number;
    this.buttonPositionY = buttonPosition.y as number;
  }

  private checkOverScreenBottom(): boolean {
    let screenHeight: number = ArkUIAdapter.px2vp(this.getDisplayInfo()?.height);
    let y: number = this.buttonPositionY + SETTING_DIALOG_POSITION_Y;
    return SETTING_DIALOG_MAX_HEIGHT + y >= screenHeight;
  }
}

// 单例
export let blurButtonVM: BlurButtonVM = SingletonHelper.getInstance(BlurButtonVM, TAG);