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

import effectKit from '@ohos.effectKit';
// import screenSessionManager from '@ohos.screenSessionManager';
import image from '@ohos.multimedia.image';
import {
  LogDomain,
  LogHelper,
  DomainName,
  TraceUtil,
  Trace
} from '@ohos/basicutils';

export interface SnapshotAndDegree {
  degree: number;
  snapshot: image.PixelMap;
  averageColor: effectKit.Color;
}

/*
 * 截图并通过取色接口获取当前屏幕的壁纸类型以及截图
 * 1-极浅壁纸；2-浅色壁纸；3-深色壁纸；4-极深壁纸；5-普通花壁纸；6-极花壁纸
 */
@Concurrent
export async function getSnapshotAndDegree(screenId: number, type: SharedArrayBuffer,
  map: image.PixelMap, rotateAngle: number): Promise<SnapshotAndDegree> {
  LogHelper.getLogHelper(LogDomain.CC, 'getScreenDegree').showInfo('start getScreenDegree');
  // 1.按照分辨率0.5截取当前屏幕
  let pixelMap: image.PixelMap = map;
  if (pixelMap) {
    await pixelMap.rotate(rotateAngle);
  } else {
    throw new Error('screenShot is empty');
  }

  LogHelper.getLogHelper(LogDomain.CC, 'CC getSnapshotAndDegree').showInfo('pixelMap returned');

  // 2.创建ColorPicker实例
  TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CREATE_PICKER);
  let colorPicker: effectKit.ColorPicker = await effectKit.createColorPicker(pixelMap).catch((err: Error) => {
    pixelMap.release();
    throw new Error('createColorPicker failed' + err);
  })
  TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_CREATE_PICKER);

  // 3.调用取色接口
  TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_GET_DEGREE);
  let degree: number = colorPicker.discriminatePitureLightDegree();
  let averageColor: effectKit.Color = colorPicker.getAverageColor();
  // MemoryUtils.removeNapiWrap(colorPicker, false);
  TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_GET_DEGREE);

  let intArray: Int32Array = new Int32Array(type);
  intArray[0] = degree;
  LogHelper.getLogHelper(LogDomain.CC, 'CC getSnapshotAndDegree').showInfo('degree is %{public}d, %{public}d',
    degree, intArray[0]);

  let res: SnapshotAndDegree = {
    degree: degree,
    averageColor: averageColor,
    snapshot: pixelMap
  }
  return res;
}