/* リンカスクリプト: このボードの Flash と RAM の配置。cortex-m-rt の link.x が読み込む */
MEMORY
{
  FLASH : ORIGIN = 0x00000000, LENGTH = 256K
  RAM   : ORIGIN = 0x20000000, LENGTH = 64K
}
