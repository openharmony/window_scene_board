/**
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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
import { SCBSceneContainerSession } from '@ohos/windowscene';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';

const TAG = 'SCBRecentCover';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);
// Cover include SCBRecentEventView, SCBRecentMinBackgroundView, SCBRecentHoverView...
export class SCBRecentCover {
  public static layoutRecentCover(sceneContainerSession: SCBSceneContainerSession, left: number, top: number): void {
    sceneContainerSession.needRenderRecentCoverTranslate.translateX = left;
    sceneContainerSession.needRenderRecentCoverTranslate.translateY = top -
    SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2 -
    SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE;
  }
}