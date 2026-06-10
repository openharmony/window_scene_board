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

import image from '@ohos.multimedia.image';
import rpc from '@ohos.rpc';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DockMenuTaskInfo, DockMenuCategoryType } from '../bean/DockMenuTaskInfo';

const TAG = 'QuickBarService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * task分组信息
 */
export class DockMenuCategory {
  public bundleName: string = '';
  public categoryId: number = -1;
  public categoryName: string = '';
  public categoryType: DockMenuCategoryType = DockMenuCategoryType.USER;
  public createTime: number = 0;
  public taskList: DockMenuTaskInfo[] = [];
}

export class QuickTaskInfo implements rpc.Parcelable {
  public taskName: string;
  public abilityName: string;
  public moduleName?: string;
  public taskIcon?: image.PixelMap;
  public taskDetail?: string;
  public parameters?: ParameterItem[];

  constructor(taskName: string, abilityName: string,
    moduleName?: string, taskIcon?: image.PixelMap, taskDetail?: string, parameters?: ParameterItem[]) {
    this.taskName = taskName;
    this.abilityName = abilityName;
    this.moduleName = moduleName;
    this.taskIcon = taskIcon;
    this.taskDetail = taskDetail;
    this.parameters = parameters;
  }

  marshalling(dataOut: rpc.MessageSequence): boolean {
    dataOut.writeString(this.taskName);
    dataOut.writeString(this.abilityName);
    dataOut.writeString(this.moduleName ?? '');
    if (!CheckEmptyUtils.isEmptyPixelMap(this.taskIcon)) {
      dataOut.writeBoolean(true);
      this.taskIcon?.marshalling(dataOut);
    } else {
      dataOut.writeBoolean(false);
    }
    dataOut.writeString(this.taskDetail ?? '');
    if (!CheckEmptyUtils.isEmptyArr(this.parameters)) {
      dataOut.writeBoolean(true);
      dataOut.writeString(JSON.stringify(this.parameters));
    } else {
      dataOut.writeBoolean(false);
    }
    return true;
  }

  unmarshalling(dataIn: rpc.MessageSequence): boolean {
    this.taskName = dataIn.readString();
    this.abilityName = dataIn.readString();
    this.moduleName = dataIn.readString();
    this.taskDetail = dataIn.readString();
    this.taskIcon = image.createPixelMapFromParcel(dataIn);
    dataIn.readParcelableArray(this.parameters);
    return true;
  }
}

export class ParameterItem implements rpc.Parcelable {
  public key: string;
  public value: string;

  constructor(key: string, value: string) {
    this.key = key;
    this.value = value;
  }

  marshalling(dataOut: rpc.MessageSequence): boolean {
    dataOut.writeString(this.key);
    dataOut.writeString(this.value);
    return true;
  }

  unmarshalling(dataIn: rpc.MessageSequence): boolean {
    this.key = dataIn.readString();
    this.value = dataIn.readString();
    return true;
  }
}

export class QuickTask implements rpc.Parcelable {
  public readonly taskId: number;
  public readonly categoryId: number;
  public taskInfo: QuickTaskInfo;

  constructor(taskId: number, categoryId: number, taskInfo: QuickTaskInfo) {
    this.taskId = taskId;
    this.categoryId = categoryId;
    this.taskInfo = taskInfo;
  }

  marshalling(dataOut: rpc.MessageSequence): boolean {
    dataOut.writeInt(this.taskId);
    dataOut.writeInt(this.categoryId);
    dataOut.writeParcelable(this.taskInfo)
    return true;
  }

  unmarshalling(dataIn: rpc.MessageSequence): boolean {
    dataIn.readInt();
    dataIn.readInt();
    this.taskInfo = new QuickTaskInfo('', '');
    dataIn.readParcelable(this.taskInfo);
    return true;
  }
}

export class CustomCategory implements rpc.Parcelable {
  public readonly categoryId: number;
  public categoryName: string;

  constructor(categoryId: number, categoryName: string) {
    this.categoryId = categoryId;
    this.categoryName = categoryName;
  }

  marshalling(dataOut: rpc.MessageSequence): boolean {
    dataOut.writeInt(this.categoryId);
    dataOut.writeString(this.categoryName)
    return true;
  }

  unmarshalling(dataIn: rpc.MessageSequence): boolean {
    dataIn.readInt();
    dataIn.readString();
    return true;
  }
}