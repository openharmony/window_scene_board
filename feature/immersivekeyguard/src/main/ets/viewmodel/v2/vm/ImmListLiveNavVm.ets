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

import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { LiveRichTextModel } from '@ohos/systemuicommon/newTsIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { ImmListData } from '../../../model/data/v2/ImmListData';
import { ImmersiveLiveNavigationVm } from './ImmersiveLiveNavigationVm';

/**
 * 沉浸列表模块实况导航卡片业务管理器
 */
@ObservedV2
export class ImmListLiveNavVm extends ImmersiveLiveNavigationVm {
  // 列表业务层
  @Computed
  get immListVm(): IImmersiveListVm | undefined {
    return this.ntfInjector?.getImmersiveListVm();
  }

  // 列表条目数据
  @Computed
  get listItemData(): ImmListData | undefined {
    return this.immListVm?.getListData(this.live?.groupKey);
  }

  // 三方实况扩展区标题样式
  @Computed
  get itemExtTitleStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.getItemHelper()?.getListStyleH(ListStyleSuffix.EXT_TITLE_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 三方实况扩展区内容样式
  @Computed
  get itemExtContentStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.getItemHelper()?.getListStyleH(ListStyleSuffix.EXT_CONTENT_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 标题文本颜色
  @Computed
  get titleFontColor(): ResourceColor | undefined {
    return this.itemExtTitleStyle?.getFontColor() ?? super.titleFontColor;
  }

  // 内容文本颜色
  public getContentFontColor(richText: LiveRichTextModel): ResourceColor | undefined {
    // AOD颜色区分加粗文字
    if (richText.textColor) {
      return this.itemExtTitleStyle?.getFontColor() ?? super.getContentFontColor(richText);
    }
    return this.itemExtContentStyle?.getFontColor() ?? super.getContentFontColor(richText);
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
      this.immListVm?.onItemIconClick(this.live.groupKey);
    };
  }
}