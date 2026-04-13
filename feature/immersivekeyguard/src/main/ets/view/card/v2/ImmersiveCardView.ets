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

import { LengthMetrics } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { SlWidgetId } from '@ohos/screenlockcommon';
import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { ImmAodZIndex } from '../../../common/constants/ImmComConst';
import { OuterCardSize } from '../../../common/constants/ImmCardConst';
import { v2Helper } from '../../../viewmodel/v2/helper/ImmersiveV2Helper';
import { ImmersiveLiveVmInjector } from '../../../viewmodel/v2/injector/ImmersiveLiveVmInjector';
import { ImmersiveNtfVmInjector } from '../../../viewmodel/v2/injector/ImmersiveNtfVmInjector';
import { ImmersiveCardItemView } from './ImmersiveCardItemView';

/**
 * V2装饰器，沉浸大卡列表主页面
 */
@ComponentV2
export struct ImmersiveCardView {
  // 状态管理器，默认通用管理器
  @Param stateMgrName: SlStateMgr = SlStateMgr.MGR_COMMON;

  // 沉浸通用业务能力注入器
  @Provider() ntfVmInjector: ImmersiveNtfVmInjector = v2Helper.getNtfInjector(this.stateMgrName) ??
    v2Helper.defaultNtfInjector;

  // 沉浸实况业务能力注入器
  @Provider() liveVmInjector: ImmersiveLiveVmInjector = v2Helper.getCardLiveInjector(this.stateMgrName) ??
    v2Helper.defaultLiveInjector;

  // 沉浸大卡业务管理器
  private cardVm: IImmersiveCardVm = this.ntfVmInjector.getImmersiveCardVm();

  // 沉浸大卡样式状态管理器
  private cardStyle: WidgetStyleStateV2 = this.cardVm?.getSlStyleState();

  // 沉浸大卡动效状态管理器
  private cardAnim: WidgetAnimStateV2 = this.cardVm?.getSlAnimState();

  aboutToAppear(): void {
    this.ntfVmInjector?.getImmDataVm()?.init();
    this.initAstcSnapshot();
  }

  aboutToDisappear(): void {
    this.ntfVmInjector?.getImmDataVm()?.destroy();
  }

  /**
   * 小外屏图片离屏渲染截图
   *
   * @param img ASTC图
   */
  @Builder
  OuterImageSnapshot(img: image.PixelMap) {
    Image(img)
      .objectFit(ImageFit.Cover)
      .draggable(false)
      .syncLoad(true)
      .autoResize(false)
      .width(OuterCardSize.WIDTH)
      .height(OuterCardSize.HEIGHT)
  }

  build() {
    Stack() {
      // 用于大卡组件位置记录
      Stack()
        .width(this.cardStyle?.getWidth())
        .height(this.cardStyle?.getHeight())
        .onAreaChange((oldValue, newValue) => this.cardVm?.onCardAreaChange(oldValue, newValue))

      Repeat(this.cardVm?.getSlCardData()).each((data) => {
        ImmersiveCardItemView({ cardData: data.item })
      })
        .key((item) => item.getNtfUid())

      // 大卡AOD截图
      Stack()
        .id(SlWidgetId.IMMERSIVE_CARD_FOR_AOD)
        .width(this.cardStyle?.getWidth())
        .height(this.cardStyle?.getHeight())
        .hitTestBehavior(HitTestMode.None)
        .zIndex(ImmAodZIndex.INDEX_AOD_VIEW)
    }
    .visibility(this.getRootVisibility())
    .padding({
      top: LengthMetrics.vp(this.cardStyle?.getPaddingT()),
      bottom: LengthMetrics.vp(this.cardStyle?.getPaddingB()),
      start: LengthMetrics.vp(this.cardStyle?.getPaddingL()),
      end: LengthMetrics.vp(this.cardStyle?.getPaddingR()),
    })
    .hitTestBehavior(HitTestMode.None)
    .width('100%')
    .height('100%')
    .opacity(this.getRootAlpha())
    .translate(this.getRootTran())
  }

  private getRootVisibility(): Visibility | undefined {
    let result = this.cardStyle?.getVisibility();
    return result;
  }

  private initAstcSnapshot(): void {
    // 离屏截图初始化
    const createBuilder = (param: image.PixelMap): CustomBuilder => this.OuterImageSnapshot(param);
    this.cardVm?.initAstcSnapshot?.(this.getUIContext(), createBuilder);
  }

  private getRootAlpha(): number | undefined {
    let styleAlpha = this.cardStyle?.getAlpha();
    // 动效场景
    if (this.cardAnim?.isWidgetAnimating()) {
      return this.cardAnim?.getAlpha() ?? styleAlpha;
    }
    return styleAlpha;
  }

  private getRootTran(): TranslateOptions | undefined {
    if (this.cardAnim?.isWidgetAnimating()) {
      return {
        x: this.cardAnim?.getTranX(),
        y: this.cardAnim.getTranY()
      };
    }
    return undefined;
  }
}