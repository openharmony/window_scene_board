/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
import { effectKit } from '@kit.ArkGraphics2D';

@Observed
export class ColorModeVolumeViewData {
  // 纯色模式音量条取色
  public volumePickColor: effectKit.Color = {red: 255, green: 255, blue: 255, alpha: 255};
  public volumeBgPickColor: effectKit.Color = {red: 255, green: 255, blue: 255, alpha: 255};
}