/*
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { GlobalContext } from '../utils/GlobalContext';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SceneIdentificationManager';
const log : LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/*
 * provide identification capability of scene state
 */
export enum SceneState {
  UNDEFINED = -1,
  RECENT_ENTER = 0,
  RECENT_EXIT,
  FOLDER_OPEN,
  FOLDER_CLOSE,
  FORM_STACK_OPEN,
  FORM_STACK_BUILD,
  GLOBAL_SEARCH_ENTER,
  GLOBAL_SEARCH_EXIT,
  GESTURE_DOCK_ENTER,
  GESTURED_DOCK_EXIT,
  EDIT_MODE_ENTER,
  EDIT_MODE_EXIT
}

export class SceneIdentificationManager {
  static readonly SCENE_IDENTIFICATION: string = 'scene_identification';

  public static notify(state: SceneState): void {
    let desktopContext: ServiceExtensionContext = GlobalContext.getContext();
    desktopContext?.eventHub.emit(SceneIdentificationManager.SCENE_IDENTIFICATION, state);
    log.showInfo(`scene identification state: ${state}`);
  }
}