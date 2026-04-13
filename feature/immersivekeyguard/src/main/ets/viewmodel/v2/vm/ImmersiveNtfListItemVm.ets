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

import { NotificationCardVm } from '@ohos/notificationcomponent/newIndex';
import { WDefault } from '@ohos/screenlockcommon';
import { WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { ListAnimSuffix, ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveDataVm } from '../../../common/interface/IImmersiveDataVm';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { IImmersiveNtfItemVm } from '../../../common/interface/IImmersiveNtfItemVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ImmListData } from '../../../model/data/v2/ImmListData';
import { SlListBindStateV2 } from '../../../model/data/v2/SlListBindStateV2';
import { ImmLiveItemDoubleTapHandler } from '../gesture/ImmLiveItemDoubleTapHandler';

/**
 * 沉浸列表条目业务管理
 */
@ObservedV2
export class ImmersiveNtfListItemVm extends NotificationCardVm implements IImmersiveNtfItemVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveNtfVmInjector;

  // 单双击处理器
  private doubleTapHandler: ImmLiveItemDoubleTapHandler = new ImmLiveItemDoubleTapHandler(this);

  // 复写播控中心图标点击回调
  public onMediaCenterIconClick: () => void = () => {
    // 侧滑拦截
    if (this.immListVm?.checkSwipeInterruptClick(this.ntf)) {
      return;
    }
    this.immListVm?.onItemIconClick(this.ntf.groupKey);
  };

  // 条目大小变化回调
  public onSizeChange = (_: SizeOptions, size: SizeOptions): void => {
    this.immListVm?.onItemSizeChange(this.ntf, _, size);
  }

  constructor(vmInjector: IImmersiveNtfVmInjector, ntf: NotificationBase) {
    super(vmInjector, ntf);
    this.vmInjector = vmInjector;
  }

  init(): void {
    super.init();
    this.doubleTapHandler.setClickCallback(() => {
      super.onItemClick(this.ntf);
    });
  }

  destroy(): void {
    super.destroy();
    this.doubleTapHandler.setClickCallback(undefined);
  }

  // 列表业务层
  @Computed
  get immListVm(): IImmersiveListVm | undefined {
    return this.vmInjector?.getImmersiveListVm();
  }

  // 当前条目数据
  @Computed
  get listItemData(): ImmListData | undefined {
    return this.immListVm?.getListData(this.ntf?.groupKey);
  }

  // 列表条目通用样式
  @Computed
  get itemComStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_COMMON_STYLE)?.getItemSt(this.ntf?.groupKey);
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

  // 列表条目中Icon样式
  @Computed
  get itemIconStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_ICON_STYLE)?.getItemSt(this.ntf.groupKey);
  }

  // 列表条目inner动效状态
  @Computed
  get itemInnerAnim(): WidgetAnimStateV2 | undefined {
    return this.getItemHelperVm()?.getListAnimH(ListAnimSuffix.ITEM_INNER_ANIM)?.getItemSt(this.ntf?.groupKey);
  }

  // 列表条目背景动效状态
  @Computed
  get itemBgAnim(): WidgetAnimStateV2 | undefined {
    return this.getItemHelperVm()?.getListAnimH(ListAnimSuffix.ITEM_BG_ANIM)?.getItemSt(this.ntf?.groupKey);
  }

  // 列表普通通知时间文本样式
  @Computed
  get itemTimeStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_TIME_STYLE)?.getItemSt(this.ntf.groupKey);
  }

  // 条目内容缩放度
  @Computed get cardContentScale(): ScaleOptions | undefined {
    if (this.itemInnerAnim?.isWidgetAnimating()) {
      return {
        x: this.itemInnerAnim?.getScaleX() ?? WDefault.MAX_VALUE,
        y: this.itemInnerAnim?.getScaleY() ?? WDefault.MAX_VALUE
      };
    }
    return undefined;
  }

  // 是否隐藏卡片背景
  @Computed get isCardBgHide(): boolean {
    // 替代背景动效显示时，临时隐藏卡片背景
    return this.itemBgAnim?.isWidgetAnimating() ?? false;
  }

  // 卡片背景高度
  @Computed get cardBgHeight(): number | string | undefined {
    return this.itemComStyle?.getBgHeight();
  }

  // 背景提亮参数
  @Computed get cardBgBrightness(): BrightnessOptions | undefined {
    return this.itemComStyle?.getBgBrightnessInner() ?? super.cardBgBrightness;
  }

  // 背板颜色
  @Computed get cardBgColor(): ResourceColor | undefined {
    // AOD存在颜色，则使用AOD颜色
    return this.itemComStyle?.getBgColor() ?? super.cardBgColor;
  }

  // 图标的透明度
  @Computed get iconAlpha(): number | undefined {
    return this.itemIconStyle?.getAlpha();
  }

  // 图标的背板可见性
  @Computed get iconBgVisible(): Visibility {
    return this.itemIconStyle?.getVisibility() ?? Visibility.None;
  }

  // 图标的背板颜色
  @Computed get iconBgColor(): ResourceColor | undefined {
    return this.itemIconStyle?.getBgColor();
  }

  // 顶部小图标的透明度
  @Computed
  get topIconAlpha(): number | undefined {
    return this.itemIconStyle?.getAlpha();
  }

  // 顶部小图标背板可见性
  @Computed
  get topBgVisible(): Visibility | undefined {
    return this.itemIconStyle?.getVisibility() ?? Visibility.None;
  }

  // 顶部小图标背板颜色
  @Computed
  get topBgColor(): ResourceColor | undefined {
    return this.itemIconStyle?.getBgColor();
  }

  // 隐私保护状态
  @Computed get isPrivacy(): boolean {
    return this.listItemData?.isDataPrivacy() ?? false;
  }

  /**
   * 标题文本颜色
   */
  @Computed get titleFontColor(): ResourceColor | undefined {
    return this.itemTitleStyle?.getFontColor() ?? super.titleFontColor;
  }

  /**
   * 内容文本颜色
   */
  @Computed get textFontColor(): ResourceColor | undefined {
    return this.itemContentStyle?.getFontColor() ?? super.textFontColor;
  }

  /**
   * 内容文本字体前景提亮参数
   */
  @Computed get fontFgBrightness(): BrightnessOptions | undefined {
    return this.itemContentStyle?.getFgBrightness() ?? super.fontFgBrightness;
  }

  // 置顶文本颜色
  @Computed get pinTopTextColor(): ResourceColor | undefined {
    // 置顶文本颜色和主文本保持一致
    return this.itemTitleStyle?.getFontColor() ?? super.pinTopTextColor;
  }

  // 置顶文本提亮参数
  @Computed get pinTopFgBrightness(): BrightnessOptions | undefined {
    // 置顶提亮参数和主文本保持一致
    return this.itemTitleStyle?.getFgBrightness() ?? super.pinTopFgBrightness;
  }

  /**
   * 普通通知时间文本可见性
   */
  @Computed get ntfTimeVisibility(): Visibility | undefined {
    return this.itemTimeStyle?.getVisibility();
  }

  /**
   * 卡片宽度
   */
  @Computed get cardWidth(): number | string {
    return '100%';
  }

  protected async onItemClick(ntf?: NotificationBase | undefined): Promise<void> {
    // 非实况通知已有vm处理单双击，直接调用父类方法
    if (!ntf?.isLiveView()) {
      super.onItemClick(ntf);
      return;
    }

    this.doubleTapHandler.requestOnClick();
  }

  onGestureJudgeBegin(info: GestureInfo): GestureJudgeResult {
    let isTarGesture = info.type === GestureControl.GestureType.PAN_GESTURE ||
      info.type === GestureControl.GestureType.SWIPE_GESTURE || info.type === GestureControl.GestureType.CLICK;
    if (!isTarGesture) {
      return GestureJudgeResult.CONTINUE;
    }
    // 下滑跟手动效时，禁用横滑与点击
    return this.getBindStV2()?.isItemSwipeEnable() ? GestureJudgeResult.CONTINUE : GestureJudgeResult.REJECT;
  }

  private getItemHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }

  private getDataVm(): IImmersiveDataVm | undefined {
    return this.vmInjector?.getImmDataVm();
  }

  private getBindStV2(): SlListBindStateV2 {
    return this.immListVm?.getSlBindState() as SlListBindStateV2;
  }
}