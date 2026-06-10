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

import { NotificationPrivacyVm } from '@ohos/notificationcomponent/src/main/ets/viewmodel/NotificationPrivacyVm';
import { ImmListData } from '../../../model/data/v2/ImmListData';
import { IImmersiveNtfPrivacyVm } from '../../../common/interface/IImmersiveNtfPrivacyVm';
import { ImmPrivacyItemDoubleTapHandler } from '../gesture/ImmPrivacyItemDoubleTapHandler';
import { NormalNotificationGroup } from '@ohos/systemuicommon/newTsIndex';

/**
 * 沉浸列表隐藏通知内容管理
 */
@ObservedV2
export class ImmersiveNtfPrivacyVm extends NotificationPrivacyVm implements IImmersiveNtfPrivacyVm {
  // 条目数据
  private _itemData?: ImmListData;

  // 单双击处理器
  private doubleTapHandler: ImmPrivacyItemDoubleTapHandler = new ImmPrivacyItemDoubleTapHandler(this);

  init(): void {
    super.init();
    this._itemData = new ImmListData(this.ntf);
    this.doubleTapHandler.setClickCallback(() => {
      super.onClick();
    });
  }

  destroy(): void {
    super.destroy();
    this.doubleTapHandler.setClickCallback(undefined);
  }

  /**
   * 是否隐藏通知内容
   *
   * @returns true 隐藏
   */
  @Computed get isHidden(): boolean {
    return this._itemData?.isDataPrivacy() ?? false;
  }

  /**
   * 获取通知简略文本
   *
   * @returns 简略文本
   */
  @Computed get content(): ResourceStr {
    return this._itemData?.mainContent ?? '';
  }

  /**
   * 是否为底部扩展实况通知
   *
   * @returns true 是底部扩展
   */
  @Computed get isExpandedLive(): boolean {
    return this._itemData?.isOtherCard() ?? false;
  }

  /**
   * 获取标题字号
   *
   * @returns 标题字号
   */
  @Computed get titleFontSize(): Length {
    return this._itemData?.isOtherCard() ? $r('sys.float.ohos_id_text_size_headline8') :
    $r('app.float.ntf_title_font_size');
  }

  /**
   * 获取标题行高
   *
   * @returns 标题行高
   */
  @Computed get titleLineHeight(): Length {
    return this._itemData?.isOtherCard() ? $r('app.float.live_view_card_hide_layout_height') :
    $r('app.float.ntf_text_line_height_fp');
  }

  onClick(): void {
    if (!this._itemData?.isLiveData()) {
      this.doubleTapHandler.requestOnClick();
      return;
    }
    // 实况通知由于直接使用cardVm，需要单独处理
    if (this.swipeVm?.offsetX !== 0) {
      this.doubleTapHandler.requestOnClick();
      return;
    }
    super.onClick();
  }
}