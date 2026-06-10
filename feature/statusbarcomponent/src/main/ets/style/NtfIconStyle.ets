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

/**
 * 通知图标资源样式
 *
 * @since 2022-11-21
 */
export class NtfIconStyle {
  /**
   * 通知图标容器左右间距
   */
  public ntfContainerPadding: Resource = $r('app.float.plugin_phone_ntf_padding');

  /**
   * 通知图标宽度
   */
  public ntfIconSize: Resource = $r('app.float.plugin_phone_ntf_icon_size');

  /**
   * 通知图标间距
   */
  public ntfIconMargin: Resource = $r('app.float.plugin_phone_ntf_icon_margin');

  /**
   * 通知图标文本大小
   */
  public ntfFontSize: Resource = $r('app.float.plugin_phone_font_size');
}