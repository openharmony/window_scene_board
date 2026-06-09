/**
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
 * UIContext工具类，提供给业务设置、获取、删除的能力
 */
export class UIContextUtil {
  private static instance: UIContextUtil;
  private uiContextMap: Map<number, UIContext> = new Map<number, UIContext>();

  private constructor() {}

  public static getInstance(): UIContextUtil {
    if (!UIContextUtil.instance) {
      UIContextUtil.instance = new UIContextUtil();
    }
    return UIContextUtil.instance;
  }

  public setUIContext(screenId: number, uiContext: UIContext): void {
    this.uiContextMap.set(screenId, uiContext);
  }

  public delUIContext(screenId: number): void {
    this.uiContextMap.delete(screenId);
  }

  public getUIContext(screenId: number): UIContext | undefined {
    return this.uiContextMap.get(screenId);
  }
}