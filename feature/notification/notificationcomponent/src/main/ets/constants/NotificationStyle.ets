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
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';

@ObservedV2
export class NotificationStyle {
  /**
   * 按钮内边距
   */
  public static readonly ITEM_PADDING = ResourceVm.instance.getNumber($r('app.float.ntf_item_padding_start_end'));
  /**
   * 按钮图标大小
   */
  public static readonly ITEM_ICON_SIZE = ResourceVm.instance.getNumber($r('app.float.ntf_item_menu_icon_size'));

  /**
   * 通知最大缩放倍数
   */
  public static readonly DEFAULT_MAX_SCALE: number = 2;
  /**
   * 横屏场景，时间组件宽度
   */
  public static readonly LANDSCAPE_HEAD_VIEW_WIDTH: string = '188vp';
  public static readonly LANDSCAPE_HEAD_VIEW_WIDTH_NUM: number = 188;
  /**
   * 横屏模式通知列表宽度所占全屏宽度比例
   */
  public static readonly LANDSCAPE_LIST_WIDTH_RATE = 0.625;
  /**
   * 状态栏下沉高度
   */
  public static readonly DROPDOWN_STATUS_BAR_HEIGHT: number = 8;

  public static getActionBtnHeight(isShowDropBar: boolean): number {
    let result: number = ResourceVm.instance.getNumber($r('app.float.ntf_text_line_height')) *
      ResourceVm.instance.getFontScale() + 2 * ResourceVm.instance.getNumber($r('app.float.ntf_buttons_top_bottom_margin'));
    // 有下拉bar时，按钮高度增加bar的高度
    if (isShowDropBar) {
      result = result + ResourceVm.instance.getNumber($r('app.float.ntf_has_drop_bar_add_height'))
    }
    return result;
  }
}