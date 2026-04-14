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
import {
  LogHelper,
  LogDomain,
  SingletonHelper,
  TraceUtil,
  DomainName,
  Trace,
  // MemoryUtils,
  FileUtils
} from '@ohos/basicutils';
import { image } from '@kit.ImageKit';
import screenSessionManager from '@ohos.screenSessionManager';
import { effectKit } from '@kit.ArkGraphics2D';
import ToggleStyle from '../template/common/StyleConfiguration';
import { BrightnessOptionUtils } from '../template/newStyle/BrightnessOptionUtils';
import fs from '@ohos.file.fs';
import base from '@ohos.base';
import { GlobalContext } from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';

const TAG = 'ColorInvertTool';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

/**
 * 文字反色工具类
 */
export class ColorInvertTool {

  public static getInstance(): ColorInvertTool {
    return SingletonHelper.getInstance(ColorInvertTool, 'ColorInvertTool');
  }

  /**
   * 根据取色接口获取壁纸类型来对文字进行提亮或者压暗：
   * 1、type1 or type2: 浅色壁纸 文字压暗
   * 2、其他类型壁纸比如极深或者普通花壁纸： 文字提亮
   * @param index
   */
  public changeLabelColor(degree: number): void {
    log.showInfo('start change label color type:' + degree);
    TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_CHANGE_LABEL_COLOR);
    if (degree === 1 || degree === 2) {
      ToggleStyle.getToggleLabelStyle().setLabelColor($r('app.color.Control_center_label_color_on_lightBackground'));
      ToggleStyle.getToggleLabelStyle().setLabelStyle(BrightnessOptionUtils.getInstance().foregroundSecondaryOption);
    } else {
      ToggleStyle.getToggleLabelStyle().setLabelColor($r('app.color.Control_center_label_color_on_darkBackground'));
      ToggleStyle.getToggleLabelStyle().setLabelStyle(BrightnessOptionUtils.getInstance()
        .foregroundSecondaryDarkOption);
    }
    TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_CHANGE_LABEL_COLOR);
  }
}

export interface SnapshotAndDegree {
  degree: number;
  snapshot: image.PixelMap;
}

/*
 * 对当前窗口进行截图并取色
 *
 * @params pixelMap 截图资源
 * @return 截图以及取色结果
 * 1-极浅壁纸；2-浅色壁纸；3-深色壁纸；4-极深壁纸；5-普通花壁纸；6-极花壁纸
 */
@Concurrent
export async function getSnapshotAndDegree(pixelMap: image.PixelMap, region: image.Region): Promise<SnapshotAndDegree> {
  LogHelper.getLogHelper(LogDomain.CC, 'getScreenDegree').showInfo('start getScreenDegree');
  if (!pixelMap) {
    throw new Error('screenShot is empty');
  }

  LogHelper.getLogHelper(LogDomain.CC, 'getScreenDegree').showInfo('start crop image');
  await pixelMap.crop(region);

  LogHelper.getLogHelper(LogDomain.CC, 'getScreenDegree').showInfo('start get degree');
  // 2.创建ColorPicker实例
  TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CREATE_PICKER);
  let colorPicker = await effectKit.createColorPicker(pixelMap).catch((err: Error) => {
    pixelMap.release();
    throw new Error('createColorPicker failed  message:' + err?.message);
  })
  TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_CREATE_PICKER);

  // 3.调用取色接口
  TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_GET_DEGREE);
  let degree: number = colorPicker.discriminatePitureLightDegree();
  // MemoryUtils.removeNapiWrap(colorPicker, false);
  TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_GET_DEGREE);
  LogHelper.getLogHelper(LogDomain.CC, 'getScreenDegree').showInfo('degree is %{public}d,', degree);
  let res: SnapshotAndDegree = {
    degree: degree,
    snapshot: pixelMap
  }
  return res;
}

@Concurrent
export async function getAvgColor(screenId: number, topRegion: number): Promise<effectKit.Color | undefined> {
  const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'GetAvgColor');
  log.showInfo('Start run getAvgColor %{public}d', screenId);
  let pixelMap: image.PixelMap | undefined = undefined;
  let color: effectKit.Color | undefined = undefined;
  let region: number[] = [0, 0, 1, topRegion];
  try {
    pixelMap = await screenSessionManager.getScreenSnapshot(screenId, 0.5, 0.5);
    color = (await effectKit.createColorPicker(pixelMap, region)).getAverageColor();
    log.showInfo(`GetAvgColor #${color.alpha}${color.red}${color.green}${color.blue}`);

    return color;
  } catch (error) {
    log.error(`GetAvgColor for ${screenId} error`, error)
  } finally {
    pixelMap?.release();
  }
  return color;
}