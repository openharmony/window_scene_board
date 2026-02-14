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
import { UIContext } from '@ohos.arkui.UIContext';

export class UIContextHelper {
  private static contexts: Map<number, UIContext> = new Map();

  public static setContext(screenId: number, context: UIContext): void {
    UIContextHelper.contexts.set(screenId, context);
  }

  public static delContext(screenId: number): void {
    UIContextHelper.contexts.delete(screenId);
  }

  public static vp2px(screenId: number, value: number): number {
    let context = UIContextHelper.contexts.get(screenId);
    if (!context) {
      return vp2px(value);
    }
    return context.vp2px(value);
  }

  public static px2vp(screenId: number, value: number): number {
    let context = UIContextHelper.contexts.get(screenId);
    if (!context) {
      return px2vp(value);
    }
    return context.px2vp(value);
  }
}