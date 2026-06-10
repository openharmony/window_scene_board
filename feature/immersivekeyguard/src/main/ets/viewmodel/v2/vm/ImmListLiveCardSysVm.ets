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

import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveLiveCardSystemVm } from '../../../common/interface/IImmersiveLiveCardSystemVm';
import { ImmersiveLiveCardSystemVm } from './ImmersiveLiveCardSystemVm';

/**
 * 列表系统实况业务管理器
 */
@ObservedV2
export class ImmListLiveCardSysVm extends ImmersiveLiveCardSystemVm implements IImmersiveLiveCardSystemVm {
  // 列表条目通用样式
  @Computed
  get itemComStyle(): WidgetStyleStateV2 | undefined {
    let helper =  this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_COMMON_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 列表条目主文本样式
  @Computed
  get itemTitleStyle(): WidgetStyleStateV2 | undefined {
    let helper =  this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_TITLE_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 列表条目副文本样式
  @Computed
  get itemContentStyle(): WidgetStyleStateV2 | undefined {
    let helper =  this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_CONTENT_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 条目图标的样式
  @Computed
  get itemIconStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_ICON_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 开启Icon点击事件
  @Computed
  get enableIconClick(): boolean {
    // 隐藏通知内容/应用锁不允许进入沉浸态
    if (this.listItemData?.isDataPrivacy()) {
      return false;
    }
    // 沉浸大卡数据，允许Icon点击
    return this.listItemData?.isSupportImmCard() ?? false;
  }

  // 图标点击事件
  @Computed
  get onIconClick(): ((event: ClickEvent) => void) | undefined {
    if (!this.enableIconClick) {
      return undefined;
    }
    return (event: ClickEvent) => {
      // 侧滑拦截
      if (this.immListVm?.checkSwipeInterruptClick(this.live)) {
        return;
      }
      this.immListVm?.onItemIconClick(this.live?.groupKey);
    };
  }

  // 应用图标透明度
  @Computed
  get iconAlpha(): number | undefined {
    return this.itemIconStyle?.getAlpha() ?? 1;
  }

  // 图标的背板可见性
  @Computed
  get iconBgVisible(): Visibility | undefined {
    return this.itemIconStyle?.getVisibility() ?? Visibility.None;
  }

  // 图标的背板颜色
  @Computed
  get iconBgColor(): ResourceColor | undefined {
    return this.itemIconStyle?.getBgColor();
  }

  // 覆盖在右上角的图标的透明度
  @Computed
  get topIconAlpha(): number | undefined {
    return this.itemIconStyle?.getAlpha();
  }

  // 覆盖在右上角的图标背板可见性
  @Computed
  get topBgVisible(): Visibility | undefined {
    return this.itemIconStyle?.getVisibility() ?? Visibility.None;
  }

  // 覆盖在右上角的图标背板颜色
  @Computed
  get topBgColor(): ResourceColor | undefined {
    return this.itemIconStyle?.getBgColor();
  }

  /**
   * 标题文本颜色
   */
  @Computed
  get titleFontColor(): ResourceColor | undefined {
    return this.itemTitleStyle?.getFontColor() ?? super.titleFontColor;
  }

  /**
   * 内容文本颜色
   */
  @Computed
  get textFontColor(): ResourceColor | undefined {
    return this.itemContentStyle?.getFontColor() ?? super.textFontColor;
  }
}