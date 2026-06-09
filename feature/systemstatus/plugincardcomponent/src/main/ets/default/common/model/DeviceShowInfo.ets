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

import rpc from '@ohos.rpc';
import { ServiceRuleInfo } from '../model/ServiceRuleInfo';
import { StringUtil } from './StringUtil';
import { DataType } from './DataType';
import Constants from './Constants';
import { ContinuityState } from './ContinuityState';

export class DeviceShowInfo extends rpc.MessageSequence {
  public deviceId: string;
  public uniqueId: string;
  public deviceName: string;
  public deviceType: string;
  public networkId: string;
  public brMac: string;
  public extraInfo: string;
  public serviceRuleList: ServiceRuleInfo[];
  public isClickPluginCard: boolean = false;
  public deviceClass?: string;
  private static readonly MAX_SERVICE_RULE_LENGTH: number = 10;
  private isTriggerByPluginCard?: boolean = false;

  constructor(deviceId: string, uniqueId: string, deviceName: string, deviceType: string,
              networkId: string, brMac: string, extraInfo: string,
              serviceRuleList: ServiceRuleInfo[]) {
    super();
    this.deviceId = deviceId;
    this.uniqueId = uniqueId;
    this.deviceName = deviceName;
    this.deviceType = deviceType;
    this.networkId = networkId;
    this.brMac = brMac;
    this.extraInfo = extraInfo;
    this.serviceRuleList = serviceRuleList;
  }

  marshalling(dataOut: rpc.MessageSequence): boolean {
    dataOut.writeString(this.deviceId);
    dataOut.writeString(this.uniqueId);
    dataOut.writeString(this.deviceName);
    dataOut.writeString(this.deviceType);
    dataOut.writeString(this.networkId);
    dataOut.writeString(this.brMac);
    dataOut.writeString(this.extraInfo);
    dataOut.writeInt(this.serviceRuleList.length);
    dataOut.writeParcelableArray(this.serviceRuleList);
    if (this.deviceType == Constants.AUDIO) {
      dataOut.writeString(this.deviceClass);
    }
    return true;
  }

  unmarshalling(dataIn: rpc.MessageSequence): boolean {
    this.deviceId = dataIn.readString();
    this.uniqueId = dataIn.readString();
    this.deviceName = dataIn.readString();
    this.deviceType = dataIn.readString();
    this.networkId = dataIn.readString();
    this.brMac = dataIn.readString();
    this.extraInfo = dataIn.readString();
    let serviceRuleLength = dataIn.readInt();
    serviceRuleLength = serviceRuleLength > DeviceShowInfo.MAX_SERVICE_RULE_LENGTH ?
    DeviceShowInfo.MAX_SERVICE_RULE_LENGTH : serviceRuleLength;
    for (let i = 0; i < serviceRuleLength; i++) {
      this.serviceRuleList.push(new ServiceRuleInfo('', 0, 0));
    }
    dataIn.readParcelableArray(this.serviceRuleList);
    if (this.deviceType == Constants.AUDIO) {
      this.deviceClass = dataIn.readString();
    }
    return true;
  }

  toString() {
    return 'deviceName: ' + this.deviceName + ', deviceType: ' + this.deviceType +
      ' , networkId: ' + StringUtil.getAnonymousData(this.networkId, DataType.NET_ID) +
      ' , brMac: ' + StringUtil.getAnonymousData(this.brMac, DataType.BT_MAC) +
      ' , extraInfo: ' + this.extraInfo + ', serviceRuleList[' + this.serviceRuleList.toString() + ']';
  }

  public getStateStr(): string {
    let stateStr = '';
    this.serviceRuleList.forEach(ruleInfo => {
      if (ruleInfo.state === ContinuityState.PREPARE || ruleInfo.state === ContinuityState.CONNECTING) {
        stateStr = stateStr + ContinuityState.CONNECTING;
      } else {
        stateStr = stateStr + ruleInfo.state;
      }
    });
    return stateStr;
  }

  public setIsClickPluginCard(isClickPluginCard: boolean): void {
    this.isClickPluginCard = isClickPluginCard;
  }

  public getIsClickPluginCard(): boolean {
    return this.isClickPluginCard;
  }

  public setIsTriggerByPluginCard(isTriggerByPluginCard: boolean): void {
    this.isTriggerByPluginCard = isTriggerByPluginCard;
  }

  public getIsTriggerByPluginCard(): boolean | undefined {
    return this.isTriggerByPluginCard;
  }
}