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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { SCBScreenProperty } from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import { FlashlightTipsConstants } from '@ohos/screenlockcommon/src/main/ets/constants/FlashlightTipsConstants';
import { FlashlightTipsHelper } from '../helper/FlashlightTipsHelper';
import { inputConsumer, KeyCode } from '@kit.InputKit';
import { FlashlightTipsUtil } from '@ohos/screenlockcommon/src/main/ets/utils/FlashlightTipsUtil';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { sensor } from '@kit.SensorServiceKit';
import { QuickToolUtil } from '@ohos/screenlockcomponent/src/main/ets/quicktools/common/StatusCacheUtil';
import { QuickToolsState } from '@ohos/screenlockcomponent/src/main/ets/quicktools/common/QuickToolConstants';

const TAG = 'FlashlightTipsModel';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class FlashlightTipsModel {
  public flashlightTipsHelper: FlashlightTipsHelper = new FlashlightTipsHelper();
  private mAnimationData: FlashlightTipsAnimationData = new FlashlightTipsAnimationData();
  private mWindowData: FlashlightTipsWindowData = new FlashlightTipsWindowData();

  /**
   * 设置数据
   *
   * @param animationData 动效数据
   * @param windowData 窗口控制数据
   */
  public setData(animationData: FlashlightTipsAnimationData, windowData: FlashlightTipsWindowData) {
    this.mAnimationData = animationData;
    this.mWindowData = windowData;
  }

  /**
   * 注册各个监听器
   */
  public registerListeners(): void {
    // 获取提示页帧动画
    this.mAnimationData.images = this.flashlightTipsHelper.getFlashlightTipsResource();
    // 注册侧滑手势
    this.flashlightTipsHelper.registerBackGestureEvent(this.backGestureCallBack);
    // 注册亮灭屏监听器
    this.flashlightTipsHelper.registerScreenListener(this.screenCallback);
    // 监听屏幕切换事件
    this.flashlightTipsHelper
      .registerScreenSessionManagerListener(this.foldToExpandChangeCallback, this.mWindowData.screenProp);
    // 注册陀螺仪监听器
    this.flashlightTipsHelper.registerGyroscopeListener(this.gyroscopeCallback);
    // 注册power键按下事件
    this.flashlightTipsHelper.registerPowerListener(this.powerKeyDownUpCallback);
  }

  /**
   * 解注册各个监听器
   */
  public unRegisterListeners(): void {
    // 注销侧滑手势
    this.flashlightTipsHelper.unRegisterBackGestureEvent();
    // 注销亮灭屏监听器
    this.flashlightTipsHelper.unRegisterScreenListener();
    // 注销监听屏幕切换事件
    this.flashlightTipsHelper
      .unRegisterScreenSessionManagerListener(this.foldToExpandChangeCallback, this.mWindowData.screenProp);
    // 注销陀螺仪监听器
    this.flashlightTipsHelper.unRegisterGyroscopeListener();
    // 注销power键按下事件
    this.flashlightTipsHelper.unRegisterPowerListener();
    // 取消屏幕常亮
    this.flashlightTipsHelper.cancelKeepScreenOn();
    // 清除重复定时器
    clearInterval(this.mWindowData.intervalID);
  }

  /**
   * power按下事件回调
   */
  public powerKeyDownUpCallback: Callback<inputConsumer.KeyOptions> = (keyOptions: inputConsumer.KeyOptions) => {
    if (keyOptions.finalKey === KeyCode.KEYCODE_POWER && keyOptions.isFinalKeyDown) {
      log.showInfo(`power key down callback`);
      // 按下power关闭手电筒打点
      FlashlightTipsUtil.flashlightTipsReport(FlashlightTipsConstants.PNAMEID,
        FlashlightTipsConstants.PVERSIONID, FlashlightTipsConstants.CLOSE_FLASHLIGHT_BY_POWER_EVENT);
      this.exitPage(true, false);
    }
  };

  /**
   * 侧滑CallBack
   */
  public backGestureCallBack = (type: GestureType, event: GestureEvent) => {
    log.showInfo(`GestureEvent Type: ${type}`);
    // 侧滑退出时,是否需要隐藏进入页面
    let isNeedExitPage: boolean = QuickToolUtil.getInstance().getToolsState() === QuickToolsState.OPEN;
    this.exitPage(isNeedExitPage, false);
  };

  /**
   * 亮灭屏监听器回调
   */
  public screenCallback = (err: BusinessError, data: commonEventManager.CommonEventData) => {
    if (err) {
      log.showInfo(`screen listener error: ${err?.message}`);
      return;
    }
    log.showInfo(`screen listener event: ${data.event}`);
    if (data.event === commonEventManager.Support.COMMON_EVENT_SCREEN_ON ||
      data.event === commonEventManager.Support.COMMON_EVENT_SCREEN_OFF) {
      // 亮灭屏事件优先隐藏
      this.mWindowData.viewController?.hide();
      this.exitPage(true, false);
    }
  }

  /**
   * 展开事件回调
   */
  public foldToExpandChangeCallback = () => {
    log.showInfo(`foldToExpandChangeCallback`);
    // 取消陀螺仪监听, 防止打开屏幕陀螺仪移动,导致开启手电筒
    this.flashlightTipsHelper?.unRegisterGyroscopeListener();
    // 展开打开手电筒回调
    FlashlightTipsUtil.flashlightTipsReport(FlashlightTipsConstants.PNAMEID
      , FlashlightTipsConstants.PVERSIONID, FlashlightTipsConstants.OPEN_FLASHLIGHT_BY_UNFOLD_EVENT);
    // 提前隐藏手电筒页面,防止闪屏
    this.mWindowData.viewController?.hide();
    // 退出页面 传递参数打开手电筒
    this.exitPage(true, true);
  }

  /**
   * 陀螺仪回调
   */
  public gyroscopeCallback = (data: sensor.GyroscopeResponse) => {
    this.mAnimationData.moveX = this.mAnimationData.moveX + data.x;
    this.mAnimationData.moveY = this.mAnimationData.moveY + data.y;
    // 如果X轴或Y轴超过角度则触发亮屏操作
    if (Math.abs(this.mAnimationData.moveX) >= FlashlightTipsConstants.ROTATION_THRESHOLD ||
      Math.abs(this.mAnimationData.moveY) >= FlashlightTipsConstants.ROTATION_THRESHOLD) {
      log.showInfo(`open flashlight by gyroscope`);
      this.mAnimationData.moveX = 0;
      this.mAnimationData.moveY = 0;
      // 打开手电筒
      FlashlightTipsUtil.openFlashlight(true);
      // 设置页面背景为白色
      this.mWindowData.pageBackgroundColor = Color.White;
      // 关闭提示页展示关闭按钮
      this.mWindowData.showClosePage = true;
      // 停止监听陀螺仪
      this.flashlightTipsHelper.unRegisterGyroscopeListener();
      // 设置屏幕常亮
      this.flashlightTipsHelper.keepScreenOn(FlashlightTipsConstants.STEADY_ON_VALUE);
      // 翻转手机触发手电筒打点
      FlashlightTipsUtil.flashlightTipsReport(FlashlightTipsConstants.PNAMEID,
        FlashlightTipsConstants.PVERSIONID, FlashlightTipsConstants.OPEN_FLASHLIGHT_BY_FLIP_EVENT);
      // 清除重复定时器
      clearInterval(this.mWindowData.intervalID);
    }
  }

  /**
   * 设置文字切换动效
   */
  public setFlashlightTipsTextAnimate(): void {
    this.setDelayPlayFlashlightTipsTextAnimate();
    this.mWindowData.intervalID = setInterval(() => {
      setTimeout(() => {
        this.playFlashlightTipsTextAnimate();
        this.setDelayPlayFlashlightTipsTextAnimate();
      }, FlashlightTipsConstants.TEXT_INIT_TIME);
    }, FlashlightTipsConstants.TEXT_VIDEO_REAPPEAR_TIME);
  }

  /**
   * 设置延迟播放文字切换动效
   */
  public setDelayPlayFlashlightTipsTextAnimate(): void {
    setTimeout(() => {
      this.playFlashlightTipsTextAnimate();
    }, FlashlightTipsConstants.TEXT_CHANGE_TIME);
  }

  /**
   * 提示字体切换动效
   *
   * @param tipsText 提示文字
   */
  public playFlashlightTipsTextAnimate(): void {
    this.oneTextMotion();
    // 第一个动画完成33ms后执行
    setTimeout(() => {
      this.twoTextMotion();
    }, FlashlightTipsConstants.TWO_TEXT_MOTION_DELAY);
  }

  /**
   * OneText组件动效
   */
  public oneTextMotion(): void {
    // OneText组件上移
    animateTo({duration: FlashlightTipsConstants.TEXT_MOTION_MOVE_TIME,
      curve: Curve.FastOutSlowIn, onFinish: () => {
        // 重新初始化组件距离
        if (this.mAnimationData.tipsTextOneOpacity === 0) {
          this.mAnimationData.tipsTextOneY = 0;
        }
      }}, () => {
      this.mAnimationData.tipsTextOneY -= FlashlightTipsConstants.ONE_TEXT_MOVE_DISTANCE;
    });
    // OneText透明度改变
    animateTo({duration: FlashlightTipsConstants.TEXT_MOTION_OPACITY_TIME,
      curve: Curve.FastOutSlowIn}, () => {
      // 改变透明度
      this.mAnimationData.tipsTextOneOpacity = this.mAnimationData.tipsTextOneOpacity == 1 ? 0 : 1;
    });
  }

  /**
   * TwoText组件动效
   */
  public twoTextMotion(): void {
    // 动效分为两块, 上移动效与淡入淡出动效, 淡入淡出动效需要在上移100ms后进行
    animateTo({duration: FlashlightTipsConstants.TEXT_MOTION_MOVE_TIME,
      curve: Curve.FastOutSlowIn, onFinish: () => {
        // 动效结束后需要初始化参数
        this.initMotionParam();
      }}, () => {
      this.mAnimationData.tipsTextTwoY -= FlashlightTipsConstants.TWO_TEXT_MOVE_DISTANCE;
    });
    // TwoText组件透明度改变
    animateTo({duration: FlashlightTipsConstants.TEXT_MOTION_OPACITY_TIME,
      curve: Curve.FastOutSlowIn, delay: FlashlightTipsConstants.TWO_TEXT_OPACITY_DELAY}, () => {
      // 改变透明度
      this.mAnimationData.tipsTextTwoOpacity = this.mAnimationData.tipsTextTwoOpacity == 1 ? 0 : 1;
    });
  }

  /**
   * 初始化动效参数
   */
  public initMotionParam(): void {
    this.mAnimationData.tipsTextOneY = 0;
    this.mAnimationData.tipsTextOneOpacity = 1;
    this.mAnimationData.tipsTextTwoOpacity = 0;
    this.mAnimationData.tipsTextTwoY = FlashlightTipsConstants.UI_TIPS_TEXT_MOTION_INITIAL_LOCATION;
  }

  /**
   * 退出页面
   *
   * @param isHideEntryPage 是否隐藏进入时的页面(如控制中心, 快捷工具)
   * @param isOpenFlashlight 是否打开手电筒
   */
  public exitPage(isHideEntryPage: boolean, isOpenFlashlight: boolean): void {
    log.showInfo(`exitPage isHideEntryPage: ${isHideEntryPage} isOpenFlashlight: ${isOpenFlashlight}`);
    // 隐藏进入时的页面
    if (isHideEntryPage) {
      FlashlightTipsUtil.closeDropdownPanel();
      QuickToolUtil.getInstance().setToolsState(QuickToolsState.CLOSE);
    }
    // 是否需要打开手电筒
    if (isOpenFlashlight) {
      FlashlightTipsUtil.openFlashlight(true);
    } else {
      FlashlightTipsUtil.closeFlashlight();
    }
    // 退出动效
    this.mWindowData.isShowPage = false;
    // 动效300ms结束 300ms后注销该组件
    setTimeout(() => {
      FlashlightTipsUtil.closeFlashlightTipsPage();
    }, FlashlightTipsConstants.QUIT_ANIMATION_DELAY);
  }
}

@Observed
export class FlashlightTipsAnimationData {
  public tipsText: ResourceStr = $r('app.string.outer_flashlight_tips');
  public mAnimationStatus: AnimationStatus = AnimationStatus.Running;
  public tipsTextOneOpacity: number = 1;
  public tipsTextTwoOpacity: number = 0;
  public tipsTextOneY: number = 0;
  public tipsTextTwoY: number = FlashlightTipsConstants.UI_TIPS_TEXT_MOTION_INITIAL_LOCATION;
  public moveX: number = 0;
  public moveY: number = 0;
  public quitMoveY: number = 0;
  public images: ImageFrameInfo[] = [];
}

@Observed
export class FlashlightTipsWindowData {
  public showClosePage: boolean = false;
  public isShowPage: boolean = true;
  public isShowTips: boolean = true;
  public pageBackgroundColor: Color = Color.Black;
  public intervalID: number = 0;
  public viewController?: BaseViewController;
  public screenProp?: SCBScreenProperty;
}