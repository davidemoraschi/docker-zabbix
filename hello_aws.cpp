#include <aws/core/Aws.h>
int main(int argc, char **argv)
{
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        // make your SDK calls here.
        Aws::Client::ClientConfiguration clientConfig;
    }
    Aws::ShutdownAPI(options);
    return 0;
}