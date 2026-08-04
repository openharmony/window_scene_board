/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import { ContractedFolderViewModelType } from '@ohos/launchercommon/src/main/ets/TsIndex';

/**
 * 手机文件夹的差异化配置
 */
export class PhoneFolderConfig {
  public static readonly modelConfig: ContractedFolderViewModelType[] = [
    ContractedFolderViewModelType.RESIZE,
    ContractedFolderViewModelType.RENAME,
    ContractedFolderViewModelType.DRAG,
    ContractedFolderViewModelType.OPEN_CLOSE,
    ContractedFolderViewModelType.LONG_PRESS,
    ContractedFolderViewModelType.CONVERT_SIZE,
    ContractedFolderViewModelType.UNINSTALL,
    ContractedFolderViewModelType.DOWNLOAD,
    ContractedFolderViewModelType.APP_EVENT];
}