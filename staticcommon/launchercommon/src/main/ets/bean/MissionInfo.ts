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
import { image } from '@kit.ImageKit';

/**
 * mission info
 */
export class MissionInfo {
  /**
   * Indicates mission id.
   */
  public missionId: number | undefined;

  /**
   * Indicates running state.
   */
  public runningState: number | undefined;

  /**
   * Indicates locked state.
   */
  public lockedState: boolean | undefined;

  /**
   * Indicates mission snapshot.
   */
  public snapshot: image.PixelMap | undefined;

  /**
   * Indicates app name of mission
   */
  public appName: string | undefined;
}