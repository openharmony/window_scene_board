/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { SCBScreenProperty, SCBScreenSessionManager, SCBRotationConfig } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RotationConstants } from '@ohos/commonconstants';

const TAG = 'SCBRotateUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/*
 * Utils function in panel
 */
export class SCBRotateUtils {
  public static getScenePanelTranslateOptions(screenProperty: SCBScreenProperty, enableRotate: boolean = true):
    TranslateOptions {
    let option: TranslateOptions = {
      x: screenProperty.getTranslateX() + 'px',
      y: screenProperty.getTranslateY() + 'px'
    };
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (screenSession && screenSession.isRotateScreenPolicy() && enableRotate) {
      // no need set translate since expand status rotate with screen
      option.x = 0;
      option.y = 0;
    }
    log.showDebug('getScenePanelTranslateOptions:{x:%{public}s,y:%{public}s}', option.x, option.y);
    return option;
  }

  public static getScenePanelRotateOptions(screenProperty: SCBScreenProperty, enableRotate: boolean = true):
    RotateOptions {
    let option: RotateOptions = {
      x: 0,
      y: 0,
      z: 1,
      angle: 0,
      centerX: '50%',
      centerY: '50%'
    };
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (screenSession && screenSession.isRotateScreenPolicy() && enableRotate) {
      return option;
    }
    option.angle = -screenProperty.rotation;
    return option;
  }

  public static getPortraitState(rotation: number): string {
    return SCBRotateUtils.isVertical(rotation) ? 'Port' : 'Land';
  }

  public static isVertical(rotation: number): boolean {
    return rotation === RotationConstants.ROTATION_0 ||
      rotation === RotationConstants.ROTATION_180 ||
      rotation === RotationConstants.ROTATION_360;
  }

  public static getScreenBorderOptions() : BorderOptions {
    let borderOptions : BorderOptions = {
      width: {
        bottom: SCBRotationConfig.getInstance().getDeviceBorderOptionsForScreen(),
      },
      color: {
        bottom: Color.Pink,
      },
    };

    return borderOptions;
  }

  public static getScenePanelBorderOptions() : BorderOptions {
    let borderOptions : BorderOptions = {
      width: {
        bottom: SCBRotationConfig.getInstance().getDeviceBorderOptionsForScenePanel(),
      },
      color: {
        bottom: Color.Green,
      },
    };

    return borderOptions;
  }

  public static getSceneContainerBorderOptions1() : BorderOptions {
    let borderOptions : BorderOptions = {
      width: {
        bottom: SCBRotationConfig.getInstance().getDeviceBorderOptionsForSceneContainer(),
      },
      color: {
        bottom: Color.Yellow,
      },
    };

    return borderOptions;
  }

  public static getSceneContainerBorderOptions2() : BorderOptions {
    let borderOptions : BorderOptions = {
      width: {
        bottom: SCBRotationConfig.getInstance().getDeviceBorderOptionsForSceneContainer(),
      },
      color: {
        bottom: Color.Orange,
      },
    };

    return borderOptions;
  }

  public static getSceneContainerBorderOptions3() : BorderOptions {
    let borderOptions : BorderOptions = {
      width: {
        bottom: SCBRotationConfig.getInstance().getDeviceBorderOptionsForSceneContainer(),
      },
      color: {
        bottom: Color.Brown,
      },
    };

    return borderOptions;
  }
}