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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import lazy { SCBScenePanelManager } from '@ohos/windowscene';
import lazy { CloseContainerParam } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import { threadCall } from '../messageChannel/ThreadCall';

const TAG = 'ScenePanelAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class ScenePanelAdapter {
  @threadCall()
  public static addCloseContainerSession(closeContainerParam: CloseContainerParam): void {
    log.showInfo(`addCloseContainerSession ${closeContainerParam}`)
    SCBScenePanelManager.getInstance().getCloseContainerSessionList().add(closeContainerParam);
  }

  public static removeCloseContainer(closeContainerParam: CloseContainerParam): void {
    log.showInfo(`removeCloseContainer ${closeContainerParam}`)
    SCBScenePanelManager.getInstance().removeCloseContainer(closeContainerParam);
  }
}