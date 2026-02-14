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
import { KeyValueArray, SCBDebugUtils } from './uiDumpUtils/SCBDebugUtils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { SCBScreenProperty, SCBScreenSession } from '../../screen/session/SCBScreenSession';
import { SCBScreenSessionArray, SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';

const TAG = 'SCBScreen';

export class SCBScreenDebugCommands {
  private readonly screenSessionList: SCBScreenSessionArray;

  constructor() {
    this.screenSessionList = SCBScreenSessionManager.getInstance().getScreenSessionList();
  }

  public register(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'screenSessionList',
        callback: (args: string[]): string => {
          return SCBScreenDebugCommands.buildScreenSessionList(this.screenSessionList);
        }
      }];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  public unregister(): void {
    DebugCommandManager.getInstance().unregister(TAG);
  }

  private static buildScreenSessionList(screenSessionList: SCBScreenSessionArray): string {
    let keyValueArrays: KeyValueArray[] = [];
    screenSessionList.forEach((screenSession: SCBScreenSession) => {
      let keyValueArray: KeyValueArray = new KeyValueArray();
      keyValueArray.push('session', screenSession.session);
      keyValueArray.push('defaultScreenOrientation', screenSession.defaultScreenOrientation);
      keyValueArray.push('scbScreenProperty',
        SCBScreenDebugCommands.buildSCBScreenPropertyObj(screenSession.scbScreenProperty));
      keyValueArray.push('sensorScreenProperty',
        SCBScreenDebugCommands.buildSCBScreenPropertyObj(screenSession.sensorScreenProperty));
      keyValueArray.push('currentSensorRotation', screenSession.currentSensorRotation);
      keyValueArray.push('isExpandStatus', screenSession.isExpandStatus);
      keyValueArray.push('isPhoneFolding', screenSession.isPhoneFolding);
      keyValueArray.push('skipRotation', screenSession.skipRotation);
      keyValueArray.push('isScreenOff', screenSession.isScreenOff);
      keyValueArray.push('isScreenOffs', 1);
      keyValueArray.push('bounds', screenSession.bounds);
      keyValueArray.push('physicalBounds', screenSession.physicalBounds);
      keyValueArray.push('availableArea', screenSession.availableArea);
      keyValueArrays.push(keyValueArray);
    });
    return SCBDebugUtils.buildArrayContext(keyValueArrays);
  }

  public static buildSCBScreenProperty(property: SCBScreenProperty): string {
    let propertyArray: KeyValueArray = SCBScreenDebugCommands.buildSCBScreenPropertyObj(property);
    return SCBDebugUtils.buildContext(propertyArray);
  }

  private static buildSCBScreenPropertyObj(property: SCBScreenProperty): KeyValueArray {
    let propertyArray: KeyValueArray = new KeyValueArray();
    propertyArray.push('left', property.left);
    propertyArray.push('top', property.top);
    propertyArray.push('width', property.width);
    propertyArray.push('height', property.height);
    propertyArray.push('radius', property.radius);
    propertyArray.push('rotation', property.rotation);
    propertyArray.push('screenId', property.screenId);
    propertyArray.push('defaultScreenOrientation', property.defaultScreenOrientation);
    propertyArray.push('translateX', property.getTranslateX());
    propertyArray.push('translateY', property.getTranslateY());
    return propertyArray;
  }
}