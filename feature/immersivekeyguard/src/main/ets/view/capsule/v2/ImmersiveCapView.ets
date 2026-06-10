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
import { SlWidgetId } from '@ohos/screenlockcommon';
import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { ImmAodZIndex } from '../../../common/constants/ImmComConst';
import { IImmersiveCapsuleHandle } from '../../../common/interface/IImmersiveCapsuleHandle';
import { IImmersiveCapVm } from '../../../common/interface/IImmersiveCapVm';
import { v2Helper } from '../../../viewmodel/v2/helper/ImmersiveV2Helper';
import { ImmersiveLiveVmInjector } from '../../../viewmodel/v2/injector/ImmersiveLiveVmInjector';
import { ImmersiveNtfVmInjector } from '../../../viewmodel/v2/injector/ImmersiveNtfVmInjector';
import { ImmersiveCapItemView } from './ImmersiveCapItemView';

/**
 * V2装饰器，沉浸胶囊列表主页面
 */
@ComponentV2
export struct ImmersiveCapView {
  // 状态管理器，默认通用管理器
  private stateMgrName: SlStateMgr = SlStateMgr.MGR_COMMON;

  // 沉浸通用业务能力注入器
  @Provider() ntfVmInjector: ImmersiveNtfVmInjector = v2Helper.getNtfInjector(this.stateMgrName) ??
    v2Helper.defaultNtfInjector;

  // 沉浸实况业务能力注入器
  @Provider() liveVmInjector: ImmersiveLiveVmInjector = v2Helper.getCapLiveInjector(this.stateMgrName) ??
    v2Helper.defaultLiveInjector;

  // 沉浸胶囊业务管理器
  private capVm: IImmersiveCapVm = this.ntfVmInjector.getImmersiveCapVm();

  // 沉浸胶囊事件管理器
  private capHandler: IImmersiveCapsuleHandle = this.ntfVmInjector.getImmersiveCapsuleHandle();

  // 沉浸胶囊样式状态管理器
  @Computed get capStyle(): WidgetStyleStateV2 {
    return this.capVm?.getSlStyleState();
  }

  // 沉浸胶囊动效状态管理器
  @Computed get capAnimSt(): WidgetAnimStateV2 {
    return this.capVm?.getSlAnimState();
  }

  aboutToAppear(): void {
    this.ntfVmInjector?.getImmDataVm()?.init();
  }

  aboutToDisappear(): void {
    this.ntfVmInjector?.getImmDataVm()?.destroy();
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Repeat(this.capVm?.getSlCapData()).each((data) => {
        ImmersiveCapItemView({ capData: data.item })
      }).key((item) => item.getNtfUid())

      // 供AOD截图使用
      Stack()
        .id(SlWidgetId.IMMERSIVE_CAP_FOR_AOD)
        .width('100%')
        .height('100%')
        .hitTestBehavior(HitTestMode.None)
        .zIndex(ImmAodZIndex.INDEX_AOD_VIEW)
    }
    .id(SlWidgetId.IMMERSIVE_CAP_SHOW_AREA)
    .clickEffect({ level: ClickEffectLevel.LIGHT })
    .clip(this.isRootClipEnable())
    .borderRadius(this.capStyle?.getBorderRadiusTL())
    .width(this.capStyle?.getWidth())
    .height(this.capStyle?.getHeight())
    .opacity(this.getRootAlpha())
    .scale(this.getRootScale())
    .translate(this.getRootTran())
    .blur(this.getRootBlur())
    .alignRules(this.capStyle?.getAlignRules())
    .onAreaChange((oldValue, newValue) => this.capVm?.onRootAreaChange(oldValue, newValue))
    .visibility(this.capStyle.getVisibility())
    .onTouch((event: TouchEvent) => this.capHandler?.onRootTouch(event))
  }

  private getRootAlpha(): number | undefined {
    let styleAlpha = this.capStyle?.getAlpha();
    // 动效场景
    if (this.capAnimSt?.isWidgetAnimating()) {
      return this.capAnimSt?.getAlpha() ?? styleAlpha;
    }
    return styleAlpha;
  }

  private getRootScale(): ScaleOptions | undefined {
    let styleScaleX = this.capStyle?.getScaleX();
    let styleScaleY = this.capStyle?.getScaleY();
    // 动效场景
    if (this.capAnimSt?.isWidgetAnimating()) {
      return {
        x: this.capAnimSt?.getScaleX() ?? styleScaleX,
        y: this.capAnimSt?.getScaleY() ?? styleScaleY
      };
    }
    return { x: styleScaleX, y: styleScaleY };
  }

  private isRootClipEnable(): boolean {
    // 动效场景
    if (this.capAnimSt?.isWidgetAnimating()) {
      return this.capAnimSt?.isClipEnable() ?? false;
    }
    return false;
  }

  private getRootBlur(): number | undefined {
    // 动效场景
    if (this.capAnimSt?.isWidgetAnimating()) {
      return this.capAnimSt?.getBlur() ?? 0;
    }
    return 0;
  }

  private getRootTran(): TranslateOptions | undefined {
    if (this.capAnimSt?.isWidgetAnimating()) {
      return {
        x: this.capAnimSt?.getTranX(),
        y: this.capAnimSt.getTranY()
      };
    }
    return undefined;
  }
}