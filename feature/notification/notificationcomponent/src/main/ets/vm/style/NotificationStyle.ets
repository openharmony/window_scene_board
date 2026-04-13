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

import { NotificationItemStyle } from './NotificationItemStyle';
import { NotificationListStyle } from './NotificationListStyle';

export class NotificationStyle {
  private _list?: NotificationListStyle;

  private _item?: NotificationItemStyle;

  public get list(): NotificationListStyle {
    if (!this._list) {
      this._list = new NotificationListStyle();
    }
    return this._list;
  }

  public get item(): NotificationItemStyle {
    if (!this._item) {
      this._item = new NotificationItemStyle();
    }
    return this._item;
  }

  public setListStyle(listStyle: NotificationListStyle): void {
    this._list = listStyle;
  }

  public setItemStyle(itemStyle: NotificationItemStyle): void {
    this._item = itemStyle;
  }

  /**
   * 通知默认icon描边参数
   *
   * @returns 描边参数
   */
  public defaultIconBorder(radius?: BorderRadiuses | Length): BorderOptions {
    return {
      width: '1px',
      color: '#3F808080',
      radius: radius
    }
  }
}

export const notificationStyle = new NotificationStyle();