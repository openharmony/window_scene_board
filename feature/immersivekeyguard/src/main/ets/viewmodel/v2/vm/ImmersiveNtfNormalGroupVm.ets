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

import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { AnimateParams } from '@ohos/systemuicommon/newIndex';
import { WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { NotificationNormalGroupVm } from '@ohos/notificationcomponent/newIndex';
import { IImmersiveNtfNormalGroupVm } from '../../../common/interface/IImmersiveNtfNormalGroupVm';
import { ListAnimScene, ListAnimSuffix, ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ImmGroupItemDoubleTapHandler } from '../gesture/ImmGroupItemDoubleTapHandler';
import { SlListStaticStateV2 } from '../../../model/data/v2/SlListStaticStateV2';

// 堆叠动效过渡浮动时长
const FOLD_FLOAT_DURATION: number = 30;

/**
 * 沉浸列表组通知条目业务管理
 */
@ObservedV2
export class ImmersiveNtfNormalGroupVm extends NotificationNormalGroupVm implements IImmersiveNtfNormalGroupVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveNtfVmInjector;

  // 单双击处理器
  private doubleTapHandler: ImmGroupItemDoubleTapHandler = new ImmGroupItemDoubleTapHandler(this);

  constructor(vmInjector: IImmersiveNtfVmInjector, ntf: NotificationBase) {
    super(vmInjector, ntf);
    this.vmInjector = vmInjector;
  }

  // 列表条目通用样式
  @Computed
  get itemComStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_COMMON_STYLE)?.getItemSt(this.ntf?.groupKey);
  }

  // 列表条目堆叠动效
  @Computed
  get itemFoldAnim(): WidgetAnimStateV2 | undefined {
    return this.getItemHelperVm()?.getListAnimH(ListAnimSuffix.ITEM_FOLD_ANIM)?.getItemSt(this.ntf?.groupKey);
  }

  // 列表条目主文本样式
  @Computed
  get itemTitleStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_TITLE_STYLE)?.getItemSt(this.ntf?.groupKey);
  }

  // 列表条目副文本样式
  @Computed
  get itemContentStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_CONTENT_STYLE)?.getItemSt(this.ntf?.groupKey);
  }

  /**
   * 标题文本颜色
   */
  @Computed get titleFontColor(): ResourceColor | undefined {
    let titleColor = this.itemTitleStyle?.getFontColor();
    if (titleColor) {
      return titleColor;
    }
    return super.titleFontColor;
  }

  /**
   * 内容文本颜色
   */
  @Computed get textFontColor(): ResourceColor | undefined {
    let conColor = this.itemContentStyle?.getFontColor();
    if (conColor) {
      return conColor;
    }
    return super.textFontColor;
  }

  /**
   * 内容文本字体前景提亮参数
   */
  @Computed get fontFgBrightness(): BrightnessOptions | undefined {
    return this.itemContentStyle?.getFgBrightness() ?? super.fontFgBrightness;
  }

  // 隐藏文本颜色
  @Computed get hideFontColor(): ResourceColor | undefined {
    // 与主文本颜色保持一致
    return this.itemTitleStyle?.getFontColor() ?? super.hideFontColor;
  }

  // 组通知个数文本颜色
  @Computed get remainderCountFontColor(): ResourceColor | undefined {
    // 与副文本颜色保持一致
    return this.itemContentStyle?.getFontColor() ?? super.remainderCountFontColor;
  }

  // 组通知个数文本前景提亮参数
  @Computed get remainderCountFgBrightness(): BrightnessOptions | undefined {
    return this.itemContentStyle?.getFgBrightness() ?? super.remainderCountFgBrightness;
  }

  // 列表根布局样式
  @Computed get listStyleSt(): WidgetStyleStateV2 | undefined {
    return this.vmInjector?.getImmersiveListVm()?.getSlStyleState();
  }

  // 组通知图标共享动效时过渡效果
  @Computed get iconTransition(): TransitionEffect | undefined {
    // 当列表顶部对齐时允许默认过渡，底部对齐时只能完全共享过渡
    return this.listStyleSt?.getHeight() ? undefined : TransitionEffect.IDENTITY;
  }

  init(): void {
    super.init();
    this.doubleTapHandler.setClickCallback(() => {
      super.onClick(this.doubleTapHandler.getIsMenuExpanded());
    });
  }

  destroy(): void {
    super.destroy();
    this.doubleTapHandler.setClickCallback(undefined);
  }

  public onClick(isMenuExpand: boolean): void {
    this.doubleTapHandler.setIsMenuExpanded(isMenuExpand);
    this.doubleTapHandler.requestOnClick();
  }

  public isFrameValid(index: number): boolean {
    // 不分帧，全部有效
    return true;
  }

  protected startSwitchExpandAnim(anim: AnimateParams): void {
    // 组通知折展动效时，记录动效参数
    let scene = this.isExpanded ? ListAnimScene.ANIM_GROUP_COLLAPSE : ListAnimScene.ANIM_GROUP_EXPAND;
    // 组通知展开时裁切慢一点，收起时裁切快一点
    let foldDuration = anim.duration;
    if (anim.duration) {
      foldDuration = this.isExpanded ? (anim.duration - FOLD_FLOAT_DURATION) : (anim.duration + FOLD_FLOAT_DURATION);
    }
    let oriFinish = anim.onFinish;
    anim.onFinish = () => {
      oriFinish?.();
      // 动效结束，清除堆叠动效
      this.getListStaticSt()?.setItemFoldAnim({ scene: scene });
    };
    // 组通知收起时，条目背景高度动效过渡，以裁切高度为准
    if (this.isExpanded) {
      this.itemComStyle?.setBgHeight(this.itemFoldAnim?.getClipHeight());
    }
    // 记录堆叠动效参数
    let foldAnim: AnimateParam = { delay: anim.delay, duration: foldDuration, curve: anim.curve };
    this.getListStaticSt()?.setItemFoldAnim({ scene: scene, animParam: foldAnim });
    // 开启动效
    super.startSwitchExpandAnim(anim);
  }

  protected onSwitchEvent(): void {
    // 组通知折展动效切换，同步切换卡片背景高度
    this.itemComStyle?.setBgHeight();
    super.onSwitchEvent();
  }

  private getListStaticSt(): SlListStaticStateV2 | undefined {
    return this.vmInjector?.getImmersiveListVm()?.getSlStaticState();
  }

  private getItemHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }
}