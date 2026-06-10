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
import { WindowAnimation, WinAnimType, WinAnimOptions } from '../animation/WindowAnimation';
import Window from '@ohos.window';

const TAG = 'SysUI_WindowAnimManager';

/**
 * 窗口动画初始透明度
 */
const WIN_BEGIN_OPACITY = 0;

/**
 * 窗口动画结束透明度
 */
const WIN_END_OPACITY = 1.0;

/**
 * 窗口动画初始缩放度
 */
const WIN_BEGIN_SCALE = 0.5;

/**
 * 窗口动画中间缩放度
 */
const WIN_MID_SCALE = 1.05;

/**
 * 窗口动画结束缩放度
 */
const WIN_END_SCALE = 1.0;

/**
 * 窗口动画中间值占比
 */
const WIN_MID_PERCENT = 0.66;

/**
 * 窗口显示动画时长，单位ms
 */
const WIN_SHOW_DURATION = 300;

/**
 * 窗口隐藏动画时长，单位ms
 */
const WIN_HIDE_DURATION = 100;

/**
 * 手机状态栏窗口动画时长，单位ms
 */
const PHONE_STATUS_WIN_ANIM_DURATION = 200;

/**
 * 手机状态栏动画延时，单位ms
 */
const PHONE_STATUS_ANIM_DELAY = 50;

/**
 * 手机状态栏隐藏动画位置，单位px
 */
const PHONE_STATUS_HIDE_POSITION = -136;

/**
 * 手机横幅显示动画时长，单位ms
 */
const PHONE_BANNER_SHOW_ANIM_DURATION = 500;

/**
 * 手机横幅隐藏动画时长，单位ms
 */
const PHONE_BANNER_HIDE_ANIM_DURATION = 300;

/**
 * 手机横幅隐藏动画位置
 */
const PHONE_BANNER_HIDE_POSITION = -420;

/**
 * 窗口动效管理
 *
 * @since 2023-02-01
 */
class WindowAnimManager {
  /**
   * 创建PC弹窗窗口动画
   *
   * @param window 窗口
   * @return 窗口动画
   */
  createPcPanelWinAnim(window: Window.Window): WindowAnimation {
    let winAnim = new WindowAnimation(window);
    let typeShow = WinAnimType.TYPE_SHOW;
    let typeHide = WinAnimType.TYPE_HIDE;
    // 设置动画时长
    winAnim.setDuration(typeShow, WIN_SHOW_DURATION);
    winAnim.setDuration(typeHide, WIN_HIDE_DURATION);

    // 设置初始值，show/hide互斥
    let beginShow = this.createWinAnimOptions(WIN_BEGIN_SCALE, WIN_BEGIN_OPACITY);
    let beginHide = this.createWinAnimOptions(WIN_END_SCALE, WIN_END_OPACITY);
    winAnim.setBeginOptions(typeShow, beginShow);
    winAnim.setBeginOptions(typeHide, beginHide);
    // show存在中间值
    let midShow = this.createWinAnimOptions(WIN_MID_SCALE, WIN_END_OPACITY);
    winAnim.setMidOptions(typeShow, midShow, WIN_MID_PERCENT);
    // 设置结束值
    let endShow = this.createWinAnimOptions(WIN_END_SCALE, WIN_END_OPACITY);
    let endHide = this.createWinAnimOptions(WIN_BEGIN_SCALE, WIN_BEGIN_OPACITY);
    winAnim.setEndOptions(typeShow, endShow);
    winAnim.setEndOptions(typeHide, endHide);
    return winAnim;
  }

  createPhoneStatusWinAnim(window: Window.Window): WindowAnimation {
    let winAnim = new WindowAnimation(window);
    let typeShow = WinAnimType.TYPE_SHOW;
    let typeHide = WinAnimType.TYPE_HIDE;
    // 设置动画时长
    winAnim.setDuration(typeShow, PHONE_STATUS_WIN_ANIM_DURATION);
    winAnim.setDuration(typeHide, PHONE_STATUS_WIN_ANIM_DURATION);

    // 设置动画延迟
    winAnim.setDelay(typeShow, PHONE_STATUS_ANIM_DELAY);

    // 设置曲线
    winAnim.setEasing(typeShow, 'cubic-bezier(0.6, 0.0, 0.6, 1.0)');
    winAnim.setEasing(typeHide, 'cubic-bezier(0.2, 0.0, 0.2, 1.0)');

    // 设置初始状态
    winAnim.setBeginOptions(typeShow, { opacity: 0});
    winAnim.setBeginOptions(typeHide, { opacity: 1});

    //设置结束状态
    winAnim.setEndOptions(typeShow, { opacity: 1});
    winAnim.setEndOptions(typeHide, { opacity: 0});
    return winAnim;
  }

  createBannerWinAnim(window: Window.Window): WindowAnimation {
    let winAnim = new WindowAnimation(window);
    let typeShow = WinAnimType.TYPE_SHOW;
    let typeHide = WinAnimType.TYPE_HIDE;
    // 设置动画时长
    winAnim.setDuration(typeShow, PHONE_BANNER_SHOW_ANIM_DURATION);
    winAnim.setDuration(typeHide, PHONE_BANNER_HIDE_ANIM_DURATION);

    // 设置曲线
    winAnim.setEasing(typeShow, 'spring(0, 1, 80, 14)');
    winAnim.setEasing(typeHide, 'cubic-bezier(0.4, 0.0, 0.4, 1.0)');

    // 设置初始状态
    winAnim.setBeginOptions(typeShow, { translate: { y: PHONE_BANNER_HIDE_POSITION } });
    winAnim.setBeginOptions(typeHide, { translate: { y: 0 } });

    // 设置结束状态
    winAnim.setEndOptions(typeShow, { translate: { y: 0 } });
    winAnim.setEndOptions(typeHide, { translate: { y: PHONE_BANNER_HIDE_POSITION } });
    return winAnim;
  }

  /**
   * 创建窗口动画参数
   *
   * @param scale 缩放度
   * @param opacity 透明度
   */
  private createWinAnimOptions(scale: number, opacity?: number): WinAnimOptions {
    let options = new WinAnimOptions();
    options.opacity = opacity;
    options.scale = {
      pivotX: 0,
      pivotY: 0,
      x: scale,
      y: scale
    };
    return options;
  }
}

// 单例
export let WindowAnimMgr: WindowAnimManager = SingletonHelper.getInstance(WindowAnimManager, TAG);