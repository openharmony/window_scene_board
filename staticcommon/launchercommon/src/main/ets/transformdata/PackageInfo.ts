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
import { CheckEmptyUtils } from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';

/**
 *  设备的迁移包信息，从app_list.json读取保存，后返回给应用市场校验
 */
export class PackageInfo {
  public appName: string = '';
  public appScanSourceDir: string = '';
  public packageName: string = '';
  public primaryCpuAbi: string = '';
  public secondaryCpuAbi: string = '';
  public sign: string = '';
  public version: string = '';
  public versionName: string = '';

  constructor(jsonObj: Object) {
    ObjectCopyUtil.simpleClone(jsonObj, this);
  }

  public isValid(): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(this.packageName)) {
      return false;
    }
    return true;
  }
}

export class AbroadPackageInfo {
  public pkgPath: string = '';
  public pkgkSize: string = '';
  public dataPath: string = '';
  public dataSize: string = '';
  public iconFile: string = '';
  public isSupportClone: string = '';
  public pkgLableName: string = '';
  public pkgName: string = '';
  public pkgSignature: string = '';
  public primaryCpuAbi: string = '';
  public secondaryCpuAbi: string = '';
  public versionCode: string = '';
  public versionName: string = '';
  public installType: string = '';
  public reserveType: string = '';

  constructor(jsonObj: Object) {
    ObjectCopyUtil.simpleClone(jsonObj, this);
  }

  public isValid(): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(this.pkgName)) {
      return false;
    }
    return true;
  }
}