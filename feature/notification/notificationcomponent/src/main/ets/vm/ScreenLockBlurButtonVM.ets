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

import { SingletonHelper } from '@ohos/basicutils';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SlMainStateType, SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { WidgetAnimState } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/bean/WidgetAnimState';
import { curves } from '@kit.ArkUI';
import { BlurButtonVM } from './BlurButtonVM'

const TAG = 'ScreenLockBlurButtonVM';
const ANIM_SCENE_MAIN_TO_SETTING = 'anim_main_to_setting';
const ANIM_SCENE_SETTING_TO_MAIN = 'anim_setting_to_main';
const ANIM_SCALE_DURATION = 350;
const ANIM_BLUR_DURATION = 250;
const ANIM_CLOSE_SETTING = 100;
const SCALE_MIN = 0.95;
const SCALE_MAX = 1.0;

@Observed
export class ScreenLockBlurButtonVM extends BlurButtonVM {
  /**
   * 左滑弹窗直接消失
   */
  private isDialogDirectHidden: boolean = false;

  public getIsDialogDirectHidden(): boolean {
    return this.isDialogDirectHidden;
  }
  /**
   * 背景模糊
   * @param buttonPosition
   */
  public blur(buttonPosition: Position): void {
    let isOldSettingShow = this.isButtonClick;
    this.isButtonClick = true;
    this.shouldBlur = true;
    this.updateButtonPosition(buttonPosition);
    if (isOldSettingShow !== this.isButtonClick) {
      this.isDialogDirectHidden = false;
      this.startSlNtfSettingAnim(true);
    }
  }

  /**
   * 取消背景模糊
   *
   * @param closeBlur 是否关闭模糊层
   */
  public unblur(closeBlur?: boolean, isDialogDirectHidden: boolean = false): void {
    let isOldSettingShow = this.isButtonClick;
    this.isButtonClick = false;
    if (closeBlur) {
      this.shouldBlur = false;
    }
    if (isOldSettingShow !== this.isButtonClick) {
      this.isDialogDirectHidden = isDialogDirectHidden;
      this.startSlNtfSettingAnim(false);
    }
  }

  /**
   * 进入/退出锁屏通知设置页面
   *
   * @Param isSettingShow 是否显示设置页
   */
  private startSlNtfSettingAnim(isSettingShow: boolean): void {
    let state = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
    let slMainAnim = state?.getSlState(SlStaticStateType.SL_MAIN_ANIM_CTR) as WidgetAnimState;
    let scene = isSettingShow ? ANIM_SCENE_MAIN_TO_SETTING : ANIM_SCENE_SETTING_TO_MAIN;
    let curve = curves.cubicBezierCurve(0.33, 0, 0.67, 1);
    slMainAnim?.setAnimScene({ isAnimating: true, animScene: scene, isForceRemove: false });
    if (isSettingShow) {
      animateTo({ duration: ANIM_SCALE_DURATION, curve: curve },
        () => slMainAnim?.setScaleX(SCALE_MIN).setScaleY(SCALE_MIN));
      animateTo({ duration: ANIM_BLUR_DURATION, curve: curve },
        () => slMainAnim?.setBlur(BlurStyle.BACKGROUND_ULTRA_THICK));
    } else {
      slMainAnim?.setAnimScene({ isAnimating: false, animScene: ANIM_SCENE_MAIN_TO_SETTING, isForceRemove: false });
      animateTo({ duration: ANIM_CLOSE_SETTING, curve: curve, onFinish: () => {
        this.setShouldBlur(false);
        slMainAnim?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: false });
      }}, () => slMainAnim?.setScaleX(SCALE_MAX).setScaleY(SCALE_MAX).setBlur(BlurStyle.NONE));
    }
  }
}

// 单例
export let screenLockBlurButtonVM: ScreenLockBlurButtonVM = SingletonHelper.getInstance(ScreenLockBlurButtonVM, TAG);