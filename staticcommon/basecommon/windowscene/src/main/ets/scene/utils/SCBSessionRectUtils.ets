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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSessionRect } from '../session/SCBSessionRect';

export class SCBSessionRectUtils {

  /**
   * compare SCBSessionRect and sceneSessionManager.SessionRect
   * @returns true when equaled, neither not
   */
  public static rectEqualsWithSessionRect(scbRect: SCBSessionRect, rect: sceneSessionManager.SessionRect): boolean {
    if (scbRect && rect) {
      return (rect.posX_ == scbRect.left.getPx()) && (rect.posY_ == scbRect.top.getPx()) &&
        (rect.width_ == scbRect.width.getPx()) && (rect.height_ == scbRect.height.getPx());
    }
    return false;
  }

  /**
   * format SessionRect to String
   */
  public static sessionRectToString(rect: sceneSessionManager.SessionRect): string {
    return '[' + rect?.posX_ + ', ' + rect?.posY_ + ', ' + rect?.width_ + ', ' + rect?.height_ + ']';
  }
}