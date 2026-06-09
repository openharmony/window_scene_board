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

export class VersionInfo {
  public majorVersion: number = 0;
  public seniorVersion: number = 0;
  public featureVersion: number = 0;
  public buildVersion: number = 0;

  constructor(majorVersion: number, seniorVersion: number, featureVersion: number, buildVersion: number) {
    this.majorVersion = majorVersion;
    this.seniorVersion = seniorVersion;
    this.featureVersion = featureVersion;
    this.buildVersion = buildVersion;
  }

  public equals(info: VersionInfo | undefined): boolean {
    if (info === undefined) {
      return false;
    }
    if (this.majorVersion !== info.majorVersion) {
      return false;
    }
    if (this.seniorVersion !== info.seniorVersion) {
      return false;
    }
    if (this.featureVersion !== info.featureVersion) {
      return false;
    }
    if (this.buildVersion !== info.buildVersion) {
      return false;
    }
    return true;
  }
}
