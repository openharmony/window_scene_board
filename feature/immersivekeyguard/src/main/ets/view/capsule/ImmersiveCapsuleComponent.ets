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

import { CommonUtils } from '@ohos/basicutils';
import { SlWidgetId } from '@ohos/screenlockcommon';
import { CapsulePositionType } from '../../common/ImmersiveConstants';
import { immersiveVm } from '../../viewmodel/ImmersiveVm';
import { immersiveKgMgr, ImmersiveState, ImmersiveType } from '@ohos/systemuicommon';
import { ImmersiveCapsuleVm } from '../../viewmodel/ImmersiveCapsuleVm';
import { ImmersiveCapsuleList } from '../../viewmodel/viewdata/ImmersiveCapsuleList';
import { ImmersiveCapsuleItem } from './ImmersiveCapsuleItem';
import { ImmersiveCapsuleStyle } from '../../model/data/ImmersiveCapsuleStyle';
import { ImmersiveAnimManager } from '../../viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveAnimKey, ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';
import { ImmersiveCapsuleHandle } from '../../viewmodel/viewevent/ImmersiveCapsuleHandle';
import { ImmersiveCapsuleConstants as CapConst } from '../../common/constants/ImmersiveCapsuleConstants';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import {
  ImmUeDataHelper,
  UeDataComp,
  UeDataType
} from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/immersivekg/helper/ImmUeDataHelper';
import { ResUtils } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';

/**
 * 沉浸式胶囊父布局
 */
@Component
export struct ImmersiveCapsuleComponent {
  /**
   * 胶囊业务管理器
   */
  private capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
  /**
   * 沉浸动效管理
   */
  private animMgr: ImmersiveAnimManager = immersiveVm.getImmersiveAnimMgr();
  /**
   * 事件管理
   */
  private eventHandle: ImmersiveCapsuleHandle = immersiveVm.getImmersiveCapsuleHandle();
  /**
   * 胶囊UI样式
   */
  @State uiStyle: ImmersiveCapsuleStyle = this.capsuleVm.getRootUiStyle();
  /**
   * 沉浸锁屏胶囊数据
   */
  @State capsuleList: ImmersiveCapsuleList = this.capsuleVm.getShowList();
  /**
   * 沉浸样式状态
   */
  @State immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
  /**
   * 动效状态
   */
  @State animState?: WidgetAnimState = this.animMgr.getCapsuleAnimState(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT);
  @Provide notificationType: number = NotificationType.TYPE_PHONE_KEYGUARD;

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 动效阴影胶囊视图
      if (this.capsuleList?.getNtfData(CapsulePositionType.TYPE_ANIM_SHADOW) && this.shouldShowAnimCapsule()) {
        ImmersiveCapsuleItem({
          isDarken: this.uiStyle.isDarken,
          capsuleType: CapsulePositionType.TYPE_ANIM_SHADOW,
          capsuleData: this.capsuleList?.getCapData(CapsulePositionType.TYPE_ANIM_SHADOW)
        })
      }

      // 阴影胶囊视图
      if (this.capsuleList?.getNtfData(CapsulePositionType.TYPE_SHADOW)) {
        ImmersiveCapsuleItem({
          isDarken: this.uiStyle.isDarken,
          capsuleType: CapsulePositionType.TYPE_SHADOW,
          capsuleData: this.capsuleList?.getCapData(CapsulePositionType.TYPE_SHADOW)
        })
      }

      // 内容胶囊视图
      if (this.capsuleList?.getNtfData(CapsulePositionType.TYPE_CONTENT)) {
        ImmersiveCapsuleItem({
          isDarken: this.uiStyle.isDarken,
          capsuleType: CapsulePositionType.TYPE_CONTENT,
          capsuleData: this.capsuleList?.getCapData(CapsulePositionType.TYPE_CONTENT)
        })
      }

      // 强提醒胶囊
      if (this.capsuleList?.getNtfData(CapsulePositionType.TYPE_REMIND)) {
        ImmersiveCapsuleItem({
          isDarken: this.uiStyle.isDarken,
          capsuleType: CapsulePositionType.TYPE_REMIND,
          capsuleData: this.capsuleList?.getCapData(CapsulePositionType.TYPE_REMIND)
        })
      }

      // 动效内容胶囊视图
      if (this.capsuleList?.getNtfData(CapsulePositionType.TYPE_ANIM_CONTENT) && this.shouldShowAnimCapsule()) {
        ImmersiveCapsuleItem({
          isDarken: this.uiStyle.isDarken,
          capsuleType: CapsulePositionType.TYPE_ANIM_CONTENT,
          capsuleData: this.capsuleList?.getCapData(CapsulePositionType.TYPE_ANIM_CONTENT)
        })
      }
      Stack()
        .width('100%')
        .height('100%')
        .id(SlWidgetId.IMMERSIVE_CAP_FOR_AOD)
        .hitTestBehavior(HitTestMode.None)
    }
    .scale(this.getRooScale())
    .width(this.uiStyle.rootWidth)
    .height(this.getRootHeight())
    .opacity(this.getRootAlpha())
    .translate(this.getCapsuleTranslate())
    .blur(this.getRootBlurRadius())
    .borderRadius(this.uiStyle.borderRadius)
    .layoutWeight(1)
    .visibility(this.getRootVisibility())
    .id(SlWidgetId.IMMERSIVE_CAP_SHOW_AREA)
    .onClick(() => {
      this.uiStyle.onClick?.();
    })
    .onTouch((event: TouchEvent) => {
      event.stopPropagation();
    })
    .gesture(PanGesture({ direction: PanDirection.Up })
      .onActionStart((event: GestureEvent) => this.eventHandle.onGestureStart(event))
      .onActionUpdate((event: GestureEvent) => this.eventHandle.onGestureUpdate(event))
      .onActionEnd((event: GestureEvent) => this.eventHandle.onGestureEnd(event))
      .onActionCancel((event?: GestureEvent) => this.eventHandle.onGestureEnd(event, true))
    )
    .onAreaChange((old, newArea) => {
      // 缓存胶囊位置
      this.animMgr.setCapsuleViewArea(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT, newArea);
    })
    .enabled(this.isEventResponse())
  }

  private getRooScale(): ScaleOptions | undefined {
    if (this.animState?.isSceneAnimating()) { // 优先根布局缩放
      return {
        x: this.animState?.getScaleX(),
        y: this.animState?.getScaleY()
      };
    }
    return undefined;
  }

  private isEventResponse(): boolean {
    if (this.immersiveState.immersiveType === ImmersiveType.TYPE_LIST) {
      return false;
    }
    if (CommonUtils.isInvalid(this.capsuleList) ||
    CommonUtils.isInvalid(this.capsuleList?.getNtfData(CapsulePositionType.TYPE_CONTENT))) {
      return false;
    }
    if (this.animState?.isSceneAnimating(ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD)) {
      return false;
    }
    return true;
  }

  private shouldShowAnimCapsule(): boolean {
    if (!this.animState?.isSceneAnimating()) {
      return false;
    }
    if (this.animState.isSceneAnimating(ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD)) {
      return false;
    }
    return true;
  }

  /**
   * 胶囊组件可见性
   *
   * @returns 可进行
   */
  private getRootVisibility(): Visibility {
    let visibility = this.getVisibility();
    ImmUeDataHelper.getInstance().setVisualParam(UeDataComp.CAP_ONE, UeDataType.VISIBILITY, visibility);
    return visibility;
  }

  private getVisibility(): Visibility {
    // 动效期间，保持显示
    if (this.animState?.isSceneAnimating()) {
      return Visibility.Visible;
    }
    return this.immersiveState?.isShowCapsule() ? Visibility.Visible : Visibility.Hidden;
  }

  /**
   * 胶囊组件高度
   *
   * @returns 高度
   */
  private getRootHeight(): number {
    return CapConst.CAPSULE_HEIGHT + CapConst.STACKED_DISTANCE;
  }

  /**
   * 胶囊组件透明度
   *
   * @returns 透明度
   */
  private getRootAlpha(): number | undefined {
    let alpha = this.getAlpha();
    ImmUeDataHelper.getInstance().setVisualParam(UeDataComp.CAP_ONE, UeDataType.OPACITY, alpha);
    return alpha;
  }

  private getAlpha(): number | undefined {
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getAlpha();
    }
    return undefined;
  }

  /**
   * 获取状态栏高度
   *
   * @returns 状态栏高度（vp）
   */
  private getStatusBarHeight(): number {

    return DeviceHelper.isPC() ? ResUtils.getNumber($r('app.float.status_bar_pc_height')) :
      ResUtils.getNumber($r('app.float.status_bar_phone_height'));
  }

  /**
   * 胶囊组件偏移值
   *
   * @returns translateOptions
   */
  private getCapsuleTranslate(): TranslateOptions {
    // 获取状态栏高度，避免胶囊与状态栏重合
    const statusBarHeight = this.getStatusBarHeight();
    if (this.animState?.isSceneAnimating()) {
      return {
        x: this.animState?.getTranX() ?? 0,
        y: statusBarHeight,
      };
    }
    return {
      x: 0,
      y: statusBarHeight,
    };
  }

  /**
   * 胶囊组件模糊半径
   *
   * @returns 模糊半径
   */
  private getRootBlurRadius(): number | undefined {
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getBlur() ?? 0;
    }
    return 0;
  }
}