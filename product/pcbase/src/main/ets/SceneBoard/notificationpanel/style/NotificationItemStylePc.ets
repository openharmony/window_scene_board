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

import { NotificationItemStyle } from '@ohos/notificationcomponent/src/main/ets/vm/style/NotificationItemStyle';

/**
 * PC通知项样式配置
 */
export class NotificationItemStylePc extends NotificationItemStyle {
  /**
   * 通知按钮文本颜色
   */
  actionButtonFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary_activated');

  /**
   * 通知按钮悬停背景色
   */
  actionButtonBgColorHover: ResourceColor = $r('sys.color.ohos_id_color_hover');

  /**
   * 通知按钮按压背景色
   */
  actionButtonBgColorPress: ResourceColor = $r('sys.color.ohos_id_color_click_effect');

  /**
   * 通知项阴影
   */
  shadow?: ShadowOptions | null = {
    radius: 8,
    color: '#1F000000',
  };
}