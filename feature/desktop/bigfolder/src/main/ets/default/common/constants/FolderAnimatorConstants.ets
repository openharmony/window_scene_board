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
 */

import { curves } from '@kit.ArkUI';
import { DeviceHelper } from '@ohos/frameworkwrapper';

/**
 * 文件夹类型
 */
export enum FolderType {
  TYPE_SMALL_FOLDER = 0x0,
  TYPE_NORMAL_BIG_FOLDER = 0x1,
  TYPE_1X2_BIG_FOLDER = 0x2,
  TYPE_2X1_BIG_FOLDER = 0x3,
  TYPE_4X2_BIG_FOLDER = 0x4,
  // 小文件夹无秩序感
  TYPE_SMALL_FOLDER_NO_SEQUENCES = 0x5,
  // 大文件夹无秩序感
  TYPE_BIG_FOLDER_NO_SEQUENCES = 0x6,

  TYPE_3X4_OPEN_FOLDER = 0x00,
  TYPE_4X4_OPEN_FOLDER = 0x10,
}

/**
 * 文件夹动效类型
 */
export enum AnimationType {
  OPEN_FOLDER_ANIMATION = 0,
  CLOSE_FOLDER_ANIMATION = 1,
  CONVERT_TO_SMALL_FOLDER_ANIMATION = 2,
  CONVERT_TO_BIG_FOLDER_ANIMATION = 3
}

/**
 * 文件夹动效名称常量
 */
export class FolderOpenCloseAnimatorConstants {
  public static readonly STACK_ICON_DARKEN_COLORS = ['#25000000', '#13000000'];
  public static animatorParamMap: Map<string, AnimateParam[]> = new Map<string, AnimateParam[]>();

  public static initMap(): void {
    let map = FolderOpenCloseAnimatorConstants.animatorParamMap;
    // 常规大文件夹To3*4参数
    let normalBigFolderOpenBottomText: AnimateParam[] = [{
      duration: 150,
      delay: 150,
      curve: Curve.Linear,
    }];
    map.set('normalBigFolderOpenBottomText', normalBigFolderOpenBottomText);
    let normalBigFolderOpenBackground: AnimateParam[] = [];
    normalBigFolderOpenBackground.push({
      duration: 200,
      curve: curves.cubicBezierCurve(0.4, 0, 0.2, 1),
    });
    normalBigFolderOpenBackground.push({
      curve: curves.interpolatingSpring(0, 1, 503.6, 39.9)
    });
    map.set('normalBigFolderOpenBackground', normalBigFolderOpenBackground);
    let normalBigFolderOpenIcon: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      normalBigFolderOpenIcon.push({
        delay: 16.67 * i,
        curve: curves.interpolatingSpring(0, 1, 503.6, 39.9),
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    map.set('normalBigFolderOpenIcon', normalBigFolderOpenIcon);
    let normalBigFolderOpenTitle: AnimateParam[] = [
      {
        duration: 500,
        curve: Curve.Friction,
      }
    ];
    map.set('normalBigFolderOpenTitle', normalBigFolderOpenTitle);
    let normalBigFolderOpenIconOpt: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      normalBigFolderOpenIconOpt.push({
        duration: 250,
        delay: 16.67 * i,
        curve: Curve.Linear,
      });
    }
    map.set('normalBigFolderOpenIconOpt', normalBigFolderOpenIconOpt);

    let normalBigFolderCloseBottomText: AnimateParam[] = [{
      duration: 100,
      curve: Curve.Linear,
    }];
    map.set('normalBigFolderCloseBottomText', normalBigFolderCloseBottomText);
    let normalBigFolderCloseBackground: AnimateParam[] = [];
    normalBigFolderCloseBackground.push({
      duration: 250,
      delay: 50,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    });
    normalBigFolderCloseBackground.push({
      delay: 50,
      curve: curves.interpolatingSpring(0, 1, 503.6, 39.9)
    });
    map.set('normalBigFolderCloseBackground', normalBigFolderCloseBackground);
    let normalBigFolderCloseIcon: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      normalBigFolderCloseIcon.push({
        delay: 16.67 * i,
        curve: curves.interpolatingSpring(0, 1, 503.6, 39.9),
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    map.set('normalBigFolderCloseIcon', normalBigFolderCloseIcon);
    let normalBigFolderCloseTitle: AnimateParam[] = [
      {
        duration: 150,
        curve: Curve.Linear,
      }
    ];
    map.set('normalBigFolderCloseTitle', normalBigFolderCloseTitle);
    let normalBigFolderCloseIconOpt: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      normalBigFolderCloseIconOpt.push({
        duration: 200,
        delay: 16.67 * i,
        curve: Curve.Linear,
      });
    }
    map.set('normalBigFolderCloseIconOpt', normalBigFolderCloseIconOpt);

    // 常规大文件夹To4*4参数
    let normalBigFolderTo4X4OpenBottomText: AnimateParam[] = [{
      duration: 250,
      delay: 200,
      curve: Curve.Linear,
    }];
    map.set('normalBigFolderTo4X4OpenBottomText', normalBigFolderTo4X4OpenBottomText);
    let normalBigFolderTo4X4OpenBackground: AnimateParam[] = [{
      duration: 200,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1)
    }];
    map.set('normalBigFolderTo4X4OpenBackground', normalBigFolderTo4X4OpenBackground);
    let normalBigFolderTo4X4OpenIcon: AnimateParam[] = [{
      duration: 350,
      curve: curves.cubicBezierCurve(0.2, 0, 0, 1),
    }];
    map.set('normalBigFolderTo4X4OpenIcon', normalBigFolderTo4X4OpenIcon);
    let normalBigFolderTo4X4OpenTitle: AnimateParam[] = [
      {
        duration: 100,
        delay: 200,
      }
    ];
    map.set('normalBigFolderTo4X4OpenTitle', normalBigFolderTo4X4OpenTitle);
    let normalBigFolderTo4X4OpenIconOpt: AnimateParam[] = [{
      duration: 100,
      curve: curves.cubicBezierCurve(0.2, 0, 0, 1),
    }];
    map.set('normalBigFolderTo4X4OpenIconOpt', normalBigFolderTo4X4OpenIconOpt);

    let normalBigFolderTo4X4CloseBottomText: AnimateParam[] = [{
      duration: 90,
      curve: Curve.Linear,
    }];
    map.set('normalBigFolderTo4X4CloseBottomText', normalBigFolderTo4X4CloseBottomText);
    let normalBigFolderTo4X4CloseBackground: AnimateParam[] = [{
      duration: 500,
      curve: curves.cubicBezierCurve(0.2, 0, 0, 1)
    }];
    map.set('normalBigFolderTo4X4CloseBackground', normalBigFolderTo4X4CloseBackground);
    let normalBigFolderTo4X4CloseIcon: AnimateParam[] = [{
      duration: 500,
      curve: curves.cubicBezierCurve(0.2, 0, 0, 1),
    }];
    map.set('normalBigFolderTo4X4CloseIcon', normalBigFolderTo4X4CloseIcon);
    let normalBigFolderTo4X4CloseTitle: AnimateParam[] = [
      {
        duration: 100,
      }
    ];
    map.set('normalBigFolderTo4X4CloseTitle', normalBigFolderTo4X4CloseTitle);
    let normalBigFolderTo4X4CloseIconOpt: AnimateParam[] = [{
      duration: 100,
      delay: 150,
      curve: curves.cubicBezierCurve(0.2, 0, 0, 1),
    }];
    map.set('normalBigFolderTo4X4CloseIconOpt', normalBigFolderTo4X4CloseIconOpt);

    // 小文件夹参数
    let smallFolderOpenBottomText: AnimateParam[] = [{
      duration: 150,
      delay: 150,
      curve: Curve.Linear,
    }];
    map.set('smallFolderOpenBottomText', smallFolderOpenBottomText);
    let smallFolderOpenBackground: AnimateParam[] = [];
    smallFolderOpenBackground.push({
      duration: 200,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    });
    smallFolderOpenBackground.push({
      curve: curves.interpolatingSpring(0, 1, 362.5, 33.9),
      delay: DeviceHelper.isPad() ? 50 : 0, // pad背板没有包住图标， UX定制
    });
    map.set('smallFolderOpenBackground', smallFolderOpenBackground);
    let smallFolderOpenIcon: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      smallFolderOpenIcon.push({
        delay: 16.67 * i,
        curve: curves.interpolatingSpring(0, 1, 362.5, 33.9),
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    map.set('smallFolderOpenIcon', smallFolderOpenIcon);
    let smallFolderOpenTitle: AnimateParam[] = [
      {
        duration: 500,
        curve: Curve.Friction,
      }
    ];
    map.set('smallFolderOpenTitle', smallFolderOpenTitle);
    let smallFolderOpenIconOpt: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      smallFolderOpenIconOpt.push({
        duration: 250,
        delay: 16.67 * i,
        curve: Curve.Linear,
      });
    }
    map.set('smallFolderOpenIconOpt', smallFolderOpenIconOpt);

    let smallFolderCloseBottomText: AnimateParam[] = [{
      duration: 100,
      curve: Curve.Linear,
    }];
    map.set('smallFolderCloseBottomText', smallFolderCloseBottomText);
    let smallFolderCloseBackground: AnimateParam[] = [];
    smallFolderCloseBackground.push({
      duration: 250,
      delay: 100,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    });
    smallFolderCloseBackground.push({
      duration: 350,
      delay: 50,
      curve: curves.interpolatingSpring(0, 1, 362.5, 33.9),
    })
    map.set('smallFolderCloseBackground', smallFolderCloseBackground);
    let smallFolderCloseIcon: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      smallFolderCloseIcon.push({
        delay: 16.67 * i,
        curve: curves.interpolatingSpring(0, 1, 362.5, 33.9),
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    map.set('smallFolderCloseIcon', smallFolderCloseIcon);
    let smallFolderCloseTitle: AnimateParam[] = [
      {
        duration: 150,
        curve: Curve.Linear,
      }
    ];
    map.set('smallFolderCloseTitle', smallFolderCloseTitle);
    let smallFolderCloseIconOpt: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      smallFolderCloseIconOpt.push({
        duration: 200,
        delay: 16.67 * i,
        curve: Curve.Linear,
      });
    }
    map.set('smallFolderCloseIconOpt', smallFolderCloseIconOpt);

    // 小文件夹To4X4参数
    let smallFolderTo4x4OpenBottomText: AnimateParam[] = [{
      duration: 150,
      delay: 150,
      curve: Curve.Linear,
    }];
    map.set('smallFolderTo4x4OpenBottomText', smallFolderTo4x4OpenBottomText);
    let smallFolderTo4x4OpenBackground: AnimateParam[] = [];
    smallFolderTo4x4OpenBackground.push({
      duration: 200,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    });
    smallFolderTo4x4OpenBackground.push({
      curve: curves.interpolatingSpring(0, 1, 247, 30),
      delay: DeviceHelper.isPad() ? 50 : 0, // pad背板没有包住图标， UX定制
    });
    map.set('smallFolderTo4x4OpenBackground', smallFolderTo4x4OpenBackground);
    let smallFolderTo4x4OpenIcon: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      smallFolderTo4x4OpenIcon.push({
        delay: 16.67 * i,
        curve: curves.interpolatingSpring(0, 1, 247, 30),
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    map.set('smallFolderTo4x4OpenIcon', smallFolderTo4x4OpenIcon);
    let smallFolderTo4x4OpenTitle: AnimateParam[] = [
      {
        duration: 500,
        curve: Curve.Friction,
      }
    ];
    map.set('smallFolderTo4x4OpenTitle', smallFolderTo4x4OpenTitle);
    let smallFolderTo4x4OpenIconOpt: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      smallFolderTo4x4OpenIconOpt.push({
        duration: 250,
        delay: 16.67 * i,
        curve: Curve.Linear,
      });
    }
    map.set('smallFolderTo4x4OpenIconOpt', smallFolderTo4x4OpenIconOpt);

    let smallFolderTo4x4CloseBottomText: AnimateParam[] = [{
      duration: 100,
      curve: Curve.Linear,
    }];
    map.set('smallFolderTo4x4CloseBottomText', smallFolderTo4x4CloseBottomText);
    let smallFolderTo4x4CloseBackground: AnimateParam[] = [];
    smallFolderTo4x4CloseBackground.push({
      duration: 250,
      delay: 100,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    });
    smallFolderTo4x4CloseBackground.push({
      duration: 350,
      delay: 50,
      curve: curves.interpolatingSpring(0, 1, 247, 30),
    });
    map.set('smallFolderTo4x4CloseBackground', smallFolderTo4x4CloseBackground);
    let smallFolderTo4x4CloseIcon: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      smallFolderTo4x4CloseIcon.push({
        delay: 16.67 * i,
        curve: curves.interpolatingSpring(0, 1, 247, 30),
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    map.set('smallFolderTo4x4CloseIcon', smallFolderTo4x4CloseIcon);
    let smallFolderTo4x4CloseTitle: AnimateParam[] = [
      {
        duration: 150,
        curve: Curve.Linear,
      }
    ];
    map.set('smallFolderTo4x4CloseTitle', smallFolderTo4x4CloseTitle);
    let smallFolderTo4x4CloseIconOpt: AnimateParam[] = [];
    for (let i = 0; i < 6; i++) {
      smallFolderTo4x4CloseIconOpt.push({
        duration: 200,
        delay: 16.67 * i,
        curve: Curve.Linear,
      });
    }
    map.set('smallFolderTo4x4CloseIconOpt', smallFolderTo4x4CloseIconOpt);

    //4*2大文件夹To3*4参数
    let bigFolder4x2OpenBottomText: AnimateParam[] = [];
    for (let i = 0; i < 4; i++) {
      bigFolder4x2OpenBottomText.push({
        duration: 150,
        delay: 150 + 33.34 * i,
        curve: Curve.Linear,
      });
    }
    map.set('bigFolder4x2OpenBottomText', bigFolder4x2OpenBottomText);
    let bigFolder4x2OpenBackground: AnimateParam[] = [];
    bigFolder4x2OpenBackground.push({
      duration: 200,
      curve: curves.cubicBezierCurve(0.4, 0, 0.2, 1),
    });
    bigFolder4x2OpenBackground.push({
      curve: curves.interpolatingSpring(0, 1, 322.3, 32)
    });
    map.set('bigFolder4x2OpenBackground', bigFolder4x2OpenBackground);
    let bigFolder4x2OpenIcon: AnimateParam[] = [];
    for (let i = 0; i < 2; i++) {
      bigFolder4x2OpenIcon.push({
        delay: 33.34 * i,
        curve: curves.interpolatingSpring(0, 1, 322.3, 32),
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    map.set('bigFolder4x2OpenIcon', bigFolder4x2OpenIcon);
    let bigFolder4x2OpenTitle: AnimateParam[] = [
      {
        duration: 500,
        curve: Curve.Friction,
      }
    ];
    map.set('bigFolder4x2OpenTitle', bigFolder4x2OpenTitle);
    let bigFolder4x2OpenIconOpt: AnimateParam[] = [];
    for (let i = 0; i < 2; i++) {
      bigFolder4x2OpenIconOpt.push({
        duration: 50,
        delay: 33.34 * i,
        curve: Curve.Linear,
      });
    }
    map.set('bigFolder4x2OpenIconOpt', bigFolder4x2OpenIconOpt);

    let bigFolder4x2CloseBottomText: AnimateParam[] = [{
      duration: 150,
      curve: Curve.Linear,
    }];
    map.set('bigFolder4x2CloseBottomText', bigFolder4x2CloseBottomText);
    let bigFolder4x2CloseBackground: AnimateParam[] = [];
    bigFolder4x2CloseBackground.push({
      duration: 250,
      delay: 50,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    });
    bigFolder4x2CloseBackground.push({
      delay: 50,
      curve: curves.interpolatingSpring(0, 1, 322.3, 32),
    })
    map.set('bigFolder4x2CloseBackground', bigFolder4x2CloseBackground);
    let bigFolder4x2CloseIcon: AnimateParam[] = [];
    for (let i = 0; i < 2; i++) {
      bigFolder4x2CloseIcon.push({
        delay: 33.34 * i,
        curve: curves.interpolatingSpring(0, 1, 322.3, 32),
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    map.set('bigFolder4x2CloseIcon', bigFolder4x2CloseIcon);
    let bigFolder4x2CloseTitle: AnimateParam[] = [
      {
        duration: 150,
        curve: Curve.Linear,
      }
    ];
    map.set('bigFolder4x2CloseTitle', bigFolder4x2CloseTitle);
    let bigFolder4x2CloseIconOpt: AnimateParam[] = [];
    bigFolder4x2CloseIconOpt.push({
      duration: 150,
      delay: 150,
      curve: Curve.Friction,
    });
    bigFolder4x2CloseIconOpt.push({
      duration: 200,
      curve: Curve.Friction,
    });
    map.set('bigFolder4x2CloseIconOpt', bigFolder4x2CloseIconOpt);

    // 小文件夹无秩序感参数
    let smallFolderNoSequenceOpenBottomText: AnimateParam[] = [{
      duration: 250,
      delay: 250,
      curve: Curve.Linear,
    }];
    map.set('smallFolderNoSequenceOpenBottomText', smallFolderNoSequenceOpenBottomText);
    let smallFolderNoSequenceOpenBackground: AnimateParam[] = [{
      duration: 200,
      curve: Curve.Linear,
    }];
    map.set('smallFolderNoSequenceOpenBackground', smallFolderNoSequenceOpenBackground);
    let smallFolderNoSequenceOpenIcon: AnimateParam[] = [{
      duration: 500,
      curve: curves.interpolatingSpring(0, 1, 223.8, 25.4),
    }];
    map.set('smallFolderNoSequenceOpenIcon', smallFolderNoSequenceOpenIcon);
    let smallFolderNoSequenceOpenTitle: AnimateParam[] = [
      {
        duration: 100,
        delay: 200,
      }
    ];
    map.set('smallFolderNoSequenceOpenTitle', smallFolderNoSequenceOpenTitle);

    let smallFolderNoSequenceCloseIcon: AnimateParam[] = [{
      duration: 500,
      curve: curves.interpolatingSpring(0, 1, 223.8, 25.4),
    }];
    map.set('smallFolderNoSequenceCloseIcon', smallFolderNoSequenceCloseIcon);
    let smallFolderNoSequenceCloseTitle: AnimateParam[] = [
      {
        duration: 100,
      }
    ];
    map.set('smallFolderNoSequenceCloseTitle', smallFolderNoSequenceCloseTitle);
  }
}