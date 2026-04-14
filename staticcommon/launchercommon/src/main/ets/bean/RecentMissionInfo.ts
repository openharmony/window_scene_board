/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
 * Recent mission info
 */
export class RecentMissionInfo {
  /**
   * Recent mission: mission id
   */
  public missionId: number | undefined;

  /**
   * Recent mission: app name
   */
  public appName: string | undefined;

  /**
   * Recent mission: app icon Id
   */
  public appIconId: number | undefined;

  /**
   * Recent mission: app label Id
   */
  public appLabelId: number | undefined;

  /**
   * Recent mission: Whether app label uses cache, used by MissionLabelUpdatedCallback
   */
  public isAppLabelUseCache: boolean | undefined = true;

  /**
   * Recent mission: bundle name
   */
  public bundleName: string | undefined;

  /**
   * Recent mission: ability name
   */
  public abilityName: string | undefined;

  /**
  * Recent mission: module name
  */
  public moduleName: string | undefined;

  /**
   * Recent mission: lock status
   */
  public lockedState: boolean | undefined;

  /**
   * Recent mission: trigger snapShot update
   */
  public snapShotTime: string | undefined;
}