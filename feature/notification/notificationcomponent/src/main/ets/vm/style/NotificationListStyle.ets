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
import { CommonUtils } from '@ohos/basicutils';

/**
 * 条目间距
 */
const DEFAULT_ITEM_SPACE = 8;

/**
 * 通知列表UI属性样式
 *
 * @since 2022-12-29
 */
export class NotificationListStyle {
  /**
   * 通知列表条目间距
   */
  public ntfItemSpace: number = DEFAULT_ITEM_SPACE;

  /**
   * 通知条目宽度
   */
  public ntfListWidth: string = '100%';

  /**
   * 左边距
   */
  public ntfRootLeftPadding: string = CommonUtils.splicePx(0);

  /**
   * 右边距
   */
  public ntfRootRightPadding: string = CommonUtils.splicePx(0);
}