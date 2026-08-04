/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { ObjectCopyUtil } from '@ohos/componenthelper';

export class TransferFormRelationModel {
  // get from intent > component
  public sourceBundleName: string = '';
  // ohos.extra.param.key.module_name
  public sourceModuleName: string = '';
  // get from intent > component
  public sourceAbilityName: string = '';
  // ohos.extra.param.key.form_name
  public sourceFormName: string = '';
  // card dimension,ohos.extra.param.key.form_dimension，use 1,2,3,4 1->2x1,2->2x2,3->2x4，4->4x4
  public sourceFormDimension: number = 0;
  // replace nundle name
  public targetBundleName: string = '';
  // replace module name
  public targetModuleName: string = '';
  // replace ability  name
  public targetAbilityName: string = '';
  // replace form  name
  public targetFormName: string = '';
  // replace form  dimension
  public targetFormDimension: number = 0;
  // form str  sourceBundleName+sourceModuleName+sourceAbilityName +sourceFormName+sourceFormDimension
  public fromString: string;

  constructor(jsonObj: Object) {
    ObjectCopyUtil.simpleClone(jsonObj, this);
    this.fromString = this.sourceBundleName + ':' + this.sourceModuleName + ':' + this.sourceAbilityName + ':' + this.sourceFormName +
      ':' + this.sourceFormDimension;
  }
}