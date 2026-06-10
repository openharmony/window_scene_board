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

import { AppIconBaseModifier } from './AppIconBaseModifier';

const TAG = 'AppIconContainerModifier';

/**
 * 图标父控件Modifier基类, 后续多场景可以继承该基类，通用能力下沉
 */
export class AppIconContainerModifier extends AppIconBaseModifier {
  private callback?: () => void;
  constructor(callback?: () => void) {
    super();
    this.callback = callback;
  }

  initializeModifier(instance: CommonAttribute): void {
    this.setTag(TAG);
    this.callback?.();
    super.initializeModifier(instance);
  }
}