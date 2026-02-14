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

import { SCBScreenProperty } from '@ohos/windowscene';
import { SCBBaseSpecificScenePanelViewModel } from '@ohos/windowscene/Index';
import { GENERAL_SCREEN_ZORDER_TO_ZINDEX } from '../config/SCBZIndexOnGeneralScreen';

/**
 * Base SpecificScenePanel ViewModel
 */
export class SCBGeneralSpecificPanelViewModel extends SCBBaseSpecificScenePanelViewModel {

  constructor(screenProperty: SCBScreenProperty) {
    super(screenProperty);
  }

  override getZIndex(): number {
    return GENERAL_SCREEN_ZORDER_TO_ZINDEX.get(this.zorder) || 0;
  }
}
